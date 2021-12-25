//
//  Atomic.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

@propertyWrapper
class Atomic<Value> {
    private var queue: DispatchQueue {
        let type = type(of: Value.self)
        return DispatchQueue(label: "\(type).\(UUID()).atomic")
    }
    private var value: Value

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
    
    var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync { value = newValue }
        }
    }
    
    func mutate(_ mutation: (inout Value) -> Void) {
        return queue.sync {
            mutation(&value)
        }
    }
}
