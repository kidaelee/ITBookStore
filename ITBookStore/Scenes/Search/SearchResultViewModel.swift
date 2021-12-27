//
//  SearchResultViewModel.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

final class SearchResultViewModel: ViewModelType {
    typealias SearchResult = Result<(books: [ITBook], hasMore: Bool), Error>
    
    @Inject private var searchITBookUseCase: SearchITBookUseCase
    private var resentlySearchKeyword: String = ""
    private var currentPage = 0
    private var totalPage = 0
    private var hasMorePage: Bool { currentPage < totalPage }
    private var nextPage: Int { hasMorePage ? currentPage + 1 : currentPage }
    private var searchResult: [ITBook] = []
    private var disposeBag = DisposeBag()
    
    struct Input {
        let searchITBooks: Observable<String>
        let readMore: Observable<Void>
    }
    
    struct Output {
        let searchResult: Driver<SearchResult>
    }
    
    func transform(input: Input) -> Output {
        let search = input.searchITBooks
            .distinctUntilChanged()
            .do(onNext: { [weak self] keyword in
                self?.resentlySearchKeyword = keyword
                self?.currentPage = 0
                self?.totalPage = 0
            })
            .flatMapLatest { [weak self] keyword -> Observable<ITBooksData> in
                guard let self = self else { return .empty() }
                return self.searchITBooks(with: keyword, page: 1)
            }
            .do(onNext: { [weak self] booksData in
                self?.totalPage = booksData.totalPage
                self?.currentPage = booksData.page
                self?.searchResult = booksData.books
            })
            .map { SearchResult.success((books: $0.books, hasMore: $0.page < $0.totalPage)) }
        
        let searchMore = input.readMore
            .flatMapFirst { [weak self] _ -> Observable<ITBooksData>  in
                guard let self = self, self.hasMorePage else { return .empty() }
                return self.searchITBooks(with: self.resentlySearchKeyword, page: self.currentPage + 1)
            }
            .do(onNext: { [weak self] booksData in
                self?.totalPage = booksData.totalPage
                self?.currentPage = booksData.page
                self?.searchResult += booksData.books
            })
            .map { [weak self] in
                SearchResult.success((books: self?.searchResult ?? [], hasMore: $0.page < $0.totalPage))
            }
        
        let searchResult = Observable<SearchResult>.merge(search, searchMore)
            .asDriver(onErrorRecover: { error in
                .just(.failure(error))
            })
        
        return Output(searchResult: searchResult)
    }
    
    private func searchITBooks(with keyword: String, page: Int?) -> Observable<ITBooksData> {
        return Observable<ITBooksData>.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let cancellable = self.searchITBookUseCase.searchITBooks(with: keyword, page: page) {
                switch $0 {
                case .success(let booksData):
                    observer.onNext(booksData)
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
