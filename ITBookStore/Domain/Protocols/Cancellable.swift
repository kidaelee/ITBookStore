//
//  Cancellable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

protocol Cancellable {
    @discardableResult
    func cancel() -> Self
}
