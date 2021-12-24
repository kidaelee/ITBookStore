//
//  ITBookStoreTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/24.
//

import XCTest
import Quick
import Nimble
@testable import ITBookStore

class ITBookStoreEntityTests: QuickSpec {

    override func spec() {
        var book1: ITBook!
        var book2: ITBook!
        describe("BookItem에서") {
            beforeEach {
                book1 = ITBook(title: "title", subtitle: "subtitle", isbn13: "123", price: "", image: "", url: "")
                book2 = ITBook(title: "제목", subtitle: "부제목", isbn13: "123", price: "", image: "", url: "")
            }
            
            context("동일한 isbn13 이라면") {
                it("동일한 책으로 간주한다") {
                    expect(book1).to(equal(book2))
                }
            }
        }
    }
}
