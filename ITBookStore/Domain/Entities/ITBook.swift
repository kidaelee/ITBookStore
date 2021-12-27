//
//  ITBook.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

struct ITBook {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}

extension ITBook: Equatable {
    public static func == (lhs: ITBook, rhs: ITBook) -> Bool {
           return lhs.isbn13 == rhs.isbn13
       }
}

protocol ITBookConvertable {
    var title: String { get }
    var subtitle: String { get }
    var isbn13: String { get }
    var price: String { get }
    var image: String { get }
    var url: String { get }
}

extension ITBookConvertable {
    var itBook: ITBook {
        .init(title: title,
              subtitle: subtitle,
              isbn13: isbn13,
              price: price,
              image: image,
              url: url)
    }
}
