//
//  ITBookDetail.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

struct ITBookDetail {
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String
    let isbn10: String
    let isbn13: String
    let pages: Int
    let year: Int
    let rating: Float
    let desc: String
    let price: String
    let image: String
    let url: String
    let pdf: [String: String]?
}


extension ITBookDetail: Equatable {
    public static func == (lhs: ITBookDetail, rhs: ITBookDetail) -> Bool {
        return lhs.isbn13 == rhs.isbn13 && lhs.isbn10 == rhs.isbn10
    }
}