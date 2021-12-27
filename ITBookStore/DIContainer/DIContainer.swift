//
//  DIContainer.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/28.
//

import Foundation

final class DIContainer {
    private var dependencies = [String: AnyObject]()
    private static var shared = DIContainer()

    private init () {}
    
    static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }

    static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency as AnyObject
    }

    private func resolve<T>() -> T {
        let key = String(describing: T.self)
        let dependency = dependencies[key] as? T

        precondition(dependency != nil, "No dependency for \(key)!")

        return dependency!
    }
}
