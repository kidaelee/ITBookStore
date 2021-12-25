//
//  API+NewITBooks.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import Alamofire

extension ITBookStoreAPI.NewITBooks: API {
    var baseUrl: String {
        ITBookStoreAPI.baseUrl
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var uri: String {
        "/new"
    }
    
    typealias Parameter = EmptyRequest
    typealias Response = NewITBooksResponse
}

struct NewITBooksResponse: ResponseConvertable {
    struct Book: Decodable {
        var title: String
        var subtitle: String
        var isbn13: String
        var price: String
        var image: String
        var url: String
    }

    var apiErrorCode: String? {
        error
    }

    var isSuccess: Bool {
        error == "0"
    }

    var error: String
    var total: String
    var books: [Book]
}
