//
//  ITBookDetailViewModel.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/27.
//

import Foundation
import RxSwift
import RxCocoa

final class ITBookDetailViewModel: ViewModelType {
    typealias FetchResult = Result<ITBookDetail, Error>
    @Inject private var searchITBookUseCase: SearchITBookUseCase
    private var fetchingIndicator = ActivityIndicator()
    private var disposeBag = DisposeBag()
    
    struct Input {
        var fecthITBookDetail: Observable<ITBook>
    }
    
    struct Output {
        var itBookDetail: Driver<FetchResult>
    }
    
    func transform(input: Input) -> Output {
        
        let itBookDetail = input.fecthITBookDetail
            .flatMapLatest { [weak self] book -> Observable<ITBookDetail> in
                guard let self = self else { return .empty() }
                return self.fetchITBookDetail(with: book.isbn13)
                    .trackActivity(self.fetchingIndicator)
            }
            .map { FetchResult.success($0) }
            .asDriver(onErrorRecover: { error in
                .just(.failure(error))
            })
        
        return Output(itBookDetail: itBookDetail)
    }
    
    private func fetchITBookDetail(with isbn: String) -> Observable<ITBookDetail> {
        return Observable<ITBookDetail>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let cancellable = self.searchITBookUseCase.getITBookDetail(with: isbn) {
                switch $0 {
                case .success(let bookDetail):
                    observer.onNext(bookDetail)
                case .failure(let error):
                    observer.onError(error)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
}
