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
