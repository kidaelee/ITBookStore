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

protocol ITBookDetailConvertable {
    var title: String { get }
    var subtitle: String { get }
    var authors: String { get }
    var publisher: String { get }
    var language: String { get }
    var isbn10: String { get }
    var isbn13: String { get }
    var pages: String { get }
    var year: String { get }
    var rating: String { get }
    var desc: String { get }
    var price: String { get }
    var image: String { get }
    var url: String { get }
    var pdf: [String: String]? { get }
}

extension ITBookDetailConvertable {
    var itBookDetail: ITBookDetail {
        .init(title: title,
              subtitle: subtitle,
              authors: authors,
              publisher: publisher,
              language: language,
              isbn10: isbn10,
              isbn13: isbn13,
              pages: pages.intValue,
              year: year.intValue,
              rating: rating.floatValue,
              desc: desc,
              price: price,
              image: image,
              url: url,
              pdf: pdf)
    }
}
