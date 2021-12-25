//
//  ViewModelType.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
