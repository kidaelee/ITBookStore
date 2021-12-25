//
//  ITBookStoreRepository.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

struct ITBookStoreRepository: ITBookRepository {
    func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void) {
        ITBookStoreAPI.ITBooks(title: title, page: page ?? 1)
            .request(parameter: EmptyRequest()) { result in
                switch result {
                case .success(let response):
                    let books = response.ITBooks
                    let isMore = response.total.intValue > response.page.intValue
                    let data = ITBooksData(books: books, isMore: isMore)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchNewITBook(completion: @escaping (Result<[ITBook], Error>) -> Void) {
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
    
    func fetchITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void) {
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
