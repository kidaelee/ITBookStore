//
//  ParameterConvertable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

protocol ParameterConvertable: Encodable {
    
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}

struct EmptyRequest: ParameterConvertable {
    
}
