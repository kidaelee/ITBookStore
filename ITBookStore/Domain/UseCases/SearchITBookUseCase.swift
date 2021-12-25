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
    func searchITBooks(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void)
    func searchNewITBooks(completion: @escaping (Result<[ITBook], Error>) -> Void)
    func getITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void)
}

struct DefaultSearchITBookUseCase: SearchITBookUseCase {
    private let repository: ITBookRepository
    
    init(repository: ITBookRepository) {
        self.repository = repository
    }
    
    func searchITBooks(with title: String, page: Int? = 1 , completion: @escaping (Result<ITBooksData, Error>) -> Void) {
        repository.fetchITBook(with: title, page: page, completion: completion)
    }
    
    func searchNewITBooks(completion: @escaping (Result<[ITBook], Error>) -> Void) {
        repository.fetchNewITBook(completion: completion)
    }
    
    func getITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) {
        repository.fetchITBookDetail(with: isbn13, completion: completion)
    }
}
