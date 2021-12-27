//
//  ITBookStoreRepository.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

struct ITBookStoreRepository: ITBookRepository {
    @discardableResult
    func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) -> Cancellable? {
        ITBookStoreAPI.ITBooks(title: title, page: page ?? 1)
            .request(parameter: EmptyRequest()) { result in
                switch result {
                case .success(let response):
                    let data = ITBooksData(books: response.books.map { $0.itBook },
                                           page: response.page.intValue,
                                           totalPage: response.total.intValue)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    @discardableResult
    func fetchNewITBook(completion: @escaping (Result<[ITBook], Error>) -> Void) -> Cancellable?  {
        ITBookStoreAPI.NewITBooks()
            .request(parameter: EmptyRequest()) { result in
                switch result {
                case .success(let response):
                    let books = response.books.map { $0.itBook }
                    completion(.success(books))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    @discardableResult
    func fetchITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) -> Cancellable?  {
        ITBookStoreAPI.ITBookDetail(isbn13: isbn13)
            .request(parameter: EmptyRequest()) { result in
                switch result {
                case .success(let response):
                    let bookDetail = response.itBookDetail
                    completion(.success(bookDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

extension ITBookStoreAPI.ITBooks.Response.Book: ITBookConvertable {}
extension ITBookStoreAPI.NewITBooks.Response.Book: ITBookConvertable { }
extension ITBookStoreAPI.ITBookDetail.Response: ITBookDetailConvertable {}
