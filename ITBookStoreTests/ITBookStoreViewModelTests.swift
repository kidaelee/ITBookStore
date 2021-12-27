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
            var disposeBag: DisposeBag!
            var searchTableViewModel: SearchTableViewModel!
            var scheduler: TestScheduler!
            var output: SearchTableViewModel.Output!
            var keywordSubject: PublishSubject<String>!
            
            beforeEach {
                disposeBag = DisposeBag()
                searchTableViewModel = SearchTableViewModel()
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
    
    struct MockITBookRepository: ITBookRepository {
        let books = [
            ITBook(title: "1", subtitle: "1", isbn13: "1", price: "1", image: "1", url: "1"),
            ITBook(title: "11", subtitle: "2", isbn13: "2", price: "2", image: "2", url: "2"),
            ITBook(title: "111", subtitle: "3", isbn13: "3", price: "3", image: "3", url: "3")
        ]
        
        let booDetail = ITBookDetail(title: "title",
                                     subtitle: "subtitle",
                                     authors: "authors",
                                     publisher: "publisher",
                                     language: "language",
                                     isbn10: "isbn10",
                                     isbn13: "isbn13",
                                     pages: 100,
                                     year: 1999,
                                     rating: 5.0,
                                     desc: "desc",
                                     price: "100",
                                     image: "",
                                     url: "",
                                     pdf: [:])
        
        func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable? {
            let data = ITBooksData(books: books, page:1, totalPage: 1)
            completion(.success(data))
            return nil
        }
        
        func fetchNewITBook(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable? {
            completion(.success(books))
            return nil
        }
        
        func fetchITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable? {
            completion(.success(booDetail))
            return nil
        }
    }
    
    override func spec() {
        describe("SearchResultViewModel에서") {
            var disposeBag: DisposeBag!
            var searchResultViewModel: SearchResultViewModel!
            var scheduler: TestScheduler!
            var output: SearchResultViewModel.Output!
            var keywordSubject: PublishSubject<String>!
            var loadMore: PublishSubject<Void>!
            var mockRepository: MockITBookRepository!
            var useCase: DefaultSearchITBookUseCase!
            
            beforeEach {
                disposeBag = DisposeBag()
                mockRepository = MockITBookRepository()
                scheduler = TestScheduler(initialClock: 1)
                useCase = DefaultSearchITBookUseCase(repository: mockRepository)
                searchResultViewModel = SearchResultViewModel(searchITBookUseCase: useCase)
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
                        expect(books).to(equal(mockRepository.books))
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
    struct MockITBookRepository: ITBookRepository {
        let books = [
            ITBook(title: "title", subtitle: "subtitle", isbn13: "isbn13", price: "100", image: "", url: "")
        ]
        
        let booDetail = ITBookDetail(title: "title",
                                     subtitle: "subtitle",
                                     authors: "authors",
                                     publisher: "publisher",
                                     language: "language",
                                     isbn10: "isbn10",
                                     isbn13: "isbn13",
                                     pages: 100,
                                     year: 1999,
                                     rating: 5.0,
                                     desc: "desc",
                                     price: "100",
                                     image: "",
                                     url: "",
                                     pdf: [:])
        
        func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable? {
            let data = ITBooksData(books: books, page:1, totalPage: 1)
            completion(.success(data))
            return nil
        }
        
        func fetchNewITBook(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable? {
            completion(.success(books))
            return nil
        }
        
        func fetchITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable? {
            completion(.success(booDetail))
            return nil
        }
    }
        
    override func spec() {
        describe("ITBookStoreDetailViewModel 에서") {
            var disposeBag: DisposeBag!
            var booksDetailViewModel: ITBookDetailViewModel!
            var scheduler: TestScheduler!
            var output: ITBookDetailViewModel.Output!
            var bookSubject: PublishSubject<ITBook>!
            var mockRepository: MockITBookRepository!
            var useCase: DefaultSearchITBookUseCase!
            
            beforeEach {
                disposeBag = DisposeBag()
                mockRepository = MockITBookRepository()
                scheduler = TestScheduler(initialClock: 1)
                useCase = DefaultSearchITBookUseCase(repository: mockRepository)
                booksDetailViewModel = ITBookDetailViewModel(searchITBookUseCase: useCase)
                bookSubject = PublishSubject<ITBook>()
                
                let intput = ITBookDetailViewModel.Input(fecthITBookDetail: bookSubject.asObservable())
                output = booksDetailViewModel.transform(input: intput)
            }
            
            context("책 상세를 요청하면") {
                beforeEach {
                    scheduler.createColdObservable(
                        [.next(10, mockRepository.books[0]),
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
                        expect(detail).to(equal(mockRepository.booDetail))
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
