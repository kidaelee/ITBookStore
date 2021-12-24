//
//  ITBookStoreRepository.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

struct ITBookStoreRepository: ITBookRepository {
    func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<[ITBook], Error>) -> Void) {
        ITBookStoreAPI.ITBooks(title: title, page: page ?? 1)
            .request(parameter: EmptyRequest()) { result in
                switch result {
                case .success(let response):
                    let books = response.books.map { $0.converToITBook() }
                    completion(.success(books))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

private extension ITBookStoreAPI.ITBooks.Response.ITBookData {
    func converToITBook() -> ITBook {
        ITBook(title: self.title,
               subtitle: self.subtitle,
               isbn13: self.isbn13,
               price: self.price,
               image: self.image,
               url: self.url)
    }
}
