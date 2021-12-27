//
//  ITBookStoreViewModelTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import Quick
import RxSwift
import RxTest
import Nimble
import RxNimble

@testable import ITBookStore

final class ITBookStoreSearchTableViewModelTests: QuickSpec {
    override func spec() {
        describe("SearchTableViewModel에") {
            var searchTableViewModel: SearchViewModel!
            var output: SearchViewModel.Output!
            var keywordSubject: PublishSubject<String>!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                searchTableViewModel = SearchViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                keywordSubject = PublishSubject<String>()
                output = searchTableViewModel.transform(input: .init(searchITBooks: keywordSubject.asObservable()))
            }
            
            context("test, test1 keywords를 stream 발행하면") {
                beforeEach {
                    scheduler.createColdObservable(
                        [.next(10, "test"),
                         .next(20, "test1")
                        ])
                        .bind(to: keywordSubject)
                        .disposed(by: disposeBag)
                }
                
                it("keyword story에서 [test, test1] event를 받는다") {
                    expect(output.recentlySearchKeyword).events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([
                            .next(0, []),
                            .next(10, ["test"]),
                            .next(20, ["test1", "test"])
                        ]))
                }
            }
        }
    }
}

final class ITBookStoreSearchResultViewModelTests: QuickSpec {
    override func spec() {
        describe("SearchResultViewModel에서") {
            var searchResultViewModel: SearchResultViewModel!
            var output: SearchResultViewModel.Output!
            var keywordSubject: PublishSubject<String>!
            var loadMore: PublishSubject<Void>!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                DIContainer.register(DefaultMockITBookRepository() as ITBookRepository)
                DIContainer.register(ITBookStoreSearchUseCase() as SearchITBookUseCase)
                searchResultViewModel = SearchResultViewModel()
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 1)
                keywordSubject = PublishSubject<String>()
                loadMore = PublishSubject<Void>()
                
                let input = SearchResultViewModel.Input(searchITBooks: keywordSubject.asObservable(),
                                                        readMore: loadMore.asObservable())
                
                output = searchResultViewModel.transform(input: input)
            }
            
            context("1이라는 키워드를 검색하면") {
                beforeEach {
                    scheduler.createColdObservable(
                        [.next(10, "1"),
                        ])
                        .bind(to: keywordSubject)
                        .disposed(by: disposeBag)
                }
                
                it("3개의 책이 반환된다") {
                    output.searchResult.drive()
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let result = try! output.searchResult.toBlocking(timeout: 3).first()
                    
                    switch result {
                    case .success(let (books: books, hasMore: hasMore)):
                        expect(books).to(equal(DefaultMockITBookRepository.books))
                        expect(hasMore).to(equal(false))
                    case .failure(_):
                        fail()
                    case .none:
                        fail()
                    }
                }
            }
        }
    }
}

final class ITBookStoreDetailViewModelTests: QuickSpec {
    override func spec() {
        describe("ITBookStoreDetailViewModel 에서") {
            var booksDetailViewModel: ITBookDetailViewModel!
            var output: ITBookDetailViewModel.Output!
            var bookSubject: PublishSubject<ITBook>!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            
            beforeEach {
                DIContainer.register(DefaultMockITBookRepository() as ITBookRepository)
                DIContainer.register(ITBookStoreSearchUseCase() as SearchITBookUseCase)
                
                booksDetailViewModel = ITBookDetailViewModel()
                
                disposeBag = DisposeBag()
                scheduler = TestScheduler(initialClock: 1)
                
                bookSubject = PublishSubject<ITBook>()
                
                let intput = ITBookDetailViewModel.Input(fecthITBookDetail: bookSubject.asObservable())
                output = booksDetailViewModel.transform(input: intput)
            }
            
            context("책 상세를 요청하면") {
                beforeEach {
                    scheduler.createColdObservable(
                        [.next(10, DefaultMockITBookRepository.books[0]),
                        ])
                        .bind(to: bookSubject)
                        .disposed(by: disposeBag)
                }
                
                it("책 상세가 응답된다") {
                    output.itBookDetail
                        .drive()
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let result = try! output.itBookDetail.toBlocking(timeout: 3).first()
                    
                    switch result {
                    case .success(let detail):
                        expect(detail).to(equal(DefaultMockITBookRepository.booDetail))
                    case .failure(_):
                        fail()
                    case .none:
                        fail()
                    }
                }
            }
        }
    }
}
