//
//  SearchITBookUseCase.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation
import UIKit

protocol SearchITBookUseCase {
    func searchITBooks(with title: String, page: Int?, completion: @escaping (Result<[ITBook], Error>) -> Void)
}

struct DefaultSearchITBookUseCase: SearchITBookUseCase {
    private let repository: ITBookRepository
    
    init(repository: ITBookRepository) {
        self.repository = repository
    }
    
    func searchITBooks(with title: String, page: Int? = 1 , completion: @escaping (Result<[ITBook], Error>) -> Void) {
        repository.fetchITBook(with: title, page: page) {
            completion($0)
        }
    }
}
