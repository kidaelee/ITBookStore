//
//  SearchITBookUseCase.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation
import UIKit

typealias ITBooksData = (books: [ITBook], page: Int, totalPage: Int)

protocol SearchITBookUseCase {
    @discardableResult
    func searchITBooks(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func searchNewITBooks(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func getITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable?
}
