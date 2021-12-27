//
//  ITBookStoreSearchUseCase.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/28.
//

import Foundation

struct ITBookStoreSearchUseCase: SearchITBookUseCase {
    @Inject private var repository: ITBookRepository

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
