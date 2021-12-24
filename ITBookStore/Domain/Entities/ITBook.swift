//
//  ITBook.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

struct ITBook {
    var title: String
    var subtitle: String
    var isbn13: String
    var price: String
    var image: String
    var url: String
}

extension ITBook: Equatable {
    public static func == (lhs: ITBook, rhs: ITBook) -> Bool {
           return lhs.isbn13 == rhs.isbn13
       }
}
