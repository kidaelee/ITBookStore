//
//  ITBookRepository.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation

protocol ITBookRepository {
    func fetchITBook(with title: String, page: Int?, completion: @escaping (Result<[ITBook], Error>) -> Void)
}


