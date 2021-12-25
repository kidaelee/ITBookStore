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
        var bookDetail1: ITBookDetail!
        var bookDetail2: ITBookDetail!
        
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
        
        describe("ITBookDetail에서") {
            beforeEach {
                bookDetail1 = ITBookDetail(title: "",
                                           subtitle: "",
                                           authors: "",
                                           publisher: "",
                                           language: "",
                                           isbn10: "1",
                                           isbn13: "2",
                                           pages: 0,
                                           year: 0,
                                           rating: 0,
                                           desc: "",
                                           price: "",
                                           image: "",
                                           url: "",
                                           pdf: nil)
                
                bookDetail2 = ITBookDetail(title: "",
                                           subtitle: "",
                                           authors: "",
                                           publisher: "",
                                           language: "",
                                           isbn10: "1",
                                           isbn13: "2",
                                           pages: 0,
                                           year: 0,
                                           rating: 0,
                                           desc: "",
                                           price: "",
                                           image: "",
                                           url: "",
                                           pdf: nil)
                
                context("동일한 isbn13, isbn10 dlfkaus") {
                    it("동일한 책 상세로 간주한다") {
                        expect(bookDetail1).to(equal(bookDetail2))
                    }
                }
            }
        }
    }
}
