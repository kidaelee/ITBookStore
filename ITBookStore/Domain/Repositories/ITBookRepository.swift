//
//  ITBookRepository.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

protocol ITBookRepository {
    func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<ITBooksData, Error>) -> Void)
    func fetchNewITBook(completion: @escaping (Result<[ITBook], Error>) -> Void)
    func fetchITBookDetail(with isbn13: String, completion: @escaping (Result<ITBookDetail, Error>) -> Void)
}


