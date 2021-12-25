//
//  ITBookSotreAPITests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import Quick
import Nimble

@testable import ITBookStore

class ITBookSotreAPITests: QuickSpec {
    override func spec() {
        describe("ITBookStoreRepository에서") {
            var repository: ITBookStoreRepository!
            
            beforeEach {
                repository = ITBookStoreRepository()
            }
            
            context("search API 호출시") {
                it("정상 동작") {
                    waitUntil(timeout: .seconds(3)) { done in
                        repository.fetchITBook(with: "mongodb", page: 1) { result in
                            switch result {
                            case .success(_):
                                break
                            case .failure(_):
                                fail()
                            }
                            done()
                        }
                    }
                }
            }
            
            context("new API 호출시") {
                it("정상 동작") {
                    waitUntil(timeout: .seconds(3)) { done in
                        repository.fetchNewITBook() { result in
                            switch result {
                            case .success(_):
                                break
                            case .failure(_):
                                fail()
                            }
                            done()
                        }
                    }
                }
            }
            
            context("dtail API 호출시") {
                it("정상 동작") {
                    waitUntil(timeout: .seconds(3)) { done in
                        repository.fetchITBookDetail(with: "9781617294136") { result in
                            switch result {
                            case .success(_):
                                break
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
