//
//  Inject.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/28.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = DIContainer.resolve()
    }
}
