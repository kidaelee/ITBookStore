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
        func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<[ITBook], Error>) -> Void) {
            let books = [
                ITBook(title: "1", subtitle: "1", isbn13: "1", price: "1", image: "1", url: "1"),
                ITBook(title: "11", subtitle: "2", isbn13: "2", price: "2", image: "2", url: "2"),
                ITBook(title: "111", subtitle: "3", isbn13: "3", price: "3", image: "3", url: "3")
            ]

            completion(.success(books))
        }
    }

    override func spec() {
        var searchITBookUseCase: SearchITBookUseCase!

        describe("SearchITBookUseCase에서") {
            beforeEach {
                searchITBookUseCase = DefaultSearchITBookUseCase(repository: MockITBookRepository())
            }

            context("검색이 성공이면 ITBook은") {
                it("3개여야 한다") {
                    waitUntil { done in
                        searchITBookUseCase.searchITBooks(with: "1", page: 1) {
                            switch $0 {
                            case .success(let books):
                                expect(books.count).to(equal(3))
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
