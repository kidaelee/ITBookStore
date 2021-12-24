//
//  ITBookStoreAPI.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

struct ITBookStoreAPI {
    static var baseUrl: String {
        "https://api.itbook.store/1.0/"
    }
    
    struct ITBooks {
        let title: String
        let page: Int
    }
    
    struct ITBookDetail {}
}
