//
//  API+ITBookDetail.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import Alamofire

extension ITBookStoreAPI.ITBookDetail: API {
    var baseUrl: String {
        ITBookStoreAPI.baseUrl
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var uri: String {
        "books/\(isbn13)"
    }
    
    typealias Parameter = EmptyRequest
    typealias Response = ITBookDetailResponse
}

struct ITBookDetailResponse: ResponseConvertable {
    
    var apiErrorCode: String? {
        error
    }
    
    var isSuccess: Bool {
        error == "0"
    }
    
    var error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let language: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let image: String
    let url: String
    let pdf: [String]
}
