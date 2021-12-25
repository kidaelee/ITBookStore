//
//  String+Extension.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation

extension String {
    var intValue: Int {
        (self as NSString).integerValue
    }
    
    var floatValue: Float {
        (self as NSString).floatValue
    }
}
