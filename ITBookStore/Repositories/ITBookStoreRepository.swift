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
                    let data = ITBooksData(books: response.ITBooks,
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
                    let books = response.ITBooks
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
                    let bookDetail = response.ITBookDetail
                    completion(.success(bookDetail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

private extension ITBookStoreAPI.ITBooks.Response {
    var ITBooks: [ITBook] {
        books.map {
            ITBookStore.ITBook(title: $0.title,
                               subtitle: $0.subtitle,
                               isbn13: $0.isbn13,
                               price: $0.price,
                               image: $0.image,
                               url: $0.url)
        }
    }
}

private extension ITBookStoreAPI.NewITBooks.Response {
    var ITBooks: [ITBook] {
        books.map {
            ITBookStore.ITBook(title: $0.title,
                               subtitle: $0.subtitle,
                               isbn13: $0.isbn13,
                               price: $0.price,
                               image: $0.image,
                               url: $0.url)
        }
    }
}

private extension ITBookStoreAPI.ITBookDetail.Response {
    var ITBookDetail: ITBookDetail {
        ITBookStore.ITBookDetail(title: title,
                                 subtitle: subtitle,
                                 authors: authors,
                                 publisher: publisher,
                                 language: language,
                                 isbn10: isbn10,
                                 isbn13: isbn13,
                                 pages: pages.intValue,
                                 year: year.intValue,
                                 rating: rating.floatValue,
                                 desc: desc,
                                 price: price,
                                 image: image,
                                 url: url,
                                 pdf: pdf)
    }
}
