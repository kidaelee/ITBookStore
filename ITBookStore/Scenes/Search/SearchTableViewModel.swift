//
//  SearchTableViewModel.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchTableViewModel: ViewModelType {
    private var resentlySearchKeyword: String = ""
    private var searchKeywordHistory: [String] = []
    private var currentPage = 0
    private var totalPage = 0
    private var hasMorePage: Bool { currentPage < totalPage }
    private var nextPage: Int { hasMorePage ? currentPage + 1 : currentPage }
    private var dispoaseBag = DisposeBag()
    
    struct Input {
        let searchITBooks: Observable<String>
    }
    
    struct Output {
        let recentlySearchKeyword: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let searchKeywordHistorySubject = BehaviorSubject<[String]>(value: searchKeywordHistory)
        
        input.searchITBooks
            .do(onNext: { [weak self] keyword in
                self?.resentlySearchKeyword = keyword
                if (self?.searchKeywordHistory.contains(keyword) ?? false) {
                    self?.searchKeywordHistory = self?.searchKeywordHistory.filter { $0 != keyword } ?? []
                }
                self?.searchKeywordHistory.insert(keyword, at: 0)
                
                self?.searchITBooks(with: keyword)
            })
            .map { [weak self] _ -> [String] in
                self?.searchKeywordHistory ?? []
            }
            .bind(to: searchKeywordHistorySubject)
            .disposed(by: dispoaseBag)
        
        
        return Output(recentlySearchKeyword: searchKeywordHistorySubject.asDriver(onErrorJustReturn: []))
    }
    
    private func searchITBooks(with keyword: String) {
        
    }
}
