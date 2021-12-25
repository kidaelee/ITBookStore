//
//  SearchITBookUseCase.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation
import UIKit

typealias ITBooksData = (books: [ITBook], isMore: Bool)

protocol SearchITBookUseCase {
    @discardableResult
    func searchITBooks(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func searchNewITBooks(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable?
    
    @discardableResult
    func getITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable?
}

struct DefaultSearchITBookUseCase: SearchITBookUseCase {
    private let repository: ITBookRepository
    
    init(repository: ITBookRepository) {
        self.repository = repository
    }
    
    @discardableResult
    func searchITBooks(with title: String, page: Int? = 1 , completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable? {
        repository.fetchITBook(with: title, page: page, completion: completion)
    }
    
    @discardableResult
    func searchNewITBooks(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable? {
        repository.fetchNewITBook(completion: completion)
    }
    
    @discardableResult
    func getITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable? {
        repository.fetchITBookDetail(with: isbn13, completion: completion)
    }
}
