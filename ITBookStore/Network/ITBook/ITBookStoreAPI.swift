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
        enum SearchMode {
            case `default`
            case new
            
            var uri: String {
                switch self {
                case .new:
                    return "new"
                case .default:
                    return "search"
                }
            }
        }
        
        let searchMode: SearchMode
        let title: String
        let page: Int
    }
    
    struct ITBookDetail {
        let isbn13: String
    }
}
