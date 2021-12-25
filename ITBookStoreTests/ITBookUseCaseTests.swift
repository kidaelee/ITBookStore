//
//  ITBookUseCaseTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/24.
//

import XCTest
import Quick
import Nimble

@testable import ITBookStore

class ITBookUseCaseTests: QuickSpec {
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
            let data = ITBooksData(books: books, isMore: false)
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
        var searchITBookUseCase: SearchITBookUseCase!
        let mockITBookRepository = MockITBookRepository()

        describe("SearchITBookUseCase에서") {
            beforeEach {
                searchITBookUseCase = DefaultSearchITBookUseCase(repository: mockITBookRepository)
            }

            context("검색이 성공이면 ITBook은") {
                it("3개여야 한다") {
                    waitUntil { done in
                        searchITBookUseCase.searchITBooks(with: "1", page: 1) {
                            switch $0 {
                            case .success(let data):
                                expect(data.books.count).to(equal(3))
                            case .failure(_):
                                fail()
                            }
                            done()
                        }
                    }
                }
            }
            
            context("ITBook detail을 검색하면") {
                it("books detail의 isbn13은 isbn13이다") {
                    waitUntil { done in
                        searchITBookUseCase.getITBookDetail(with: "isbn13") {
                            switch $0 {
                            case .success(let detail):
                                expect(detail).to(equal(mockITBookRepository.booDetail))
                            case .failure(_):
                                fail()
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
