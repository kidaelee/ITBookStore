//
//  APIError.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

enum APIError: Error {
    case networkError(_ reason: String)
    case apiError(_ reason: String)
}
