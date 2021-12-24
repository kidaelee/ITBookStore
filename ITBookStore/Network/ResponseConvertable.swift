//
//  ResponseConvertable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import SwiftyJSON

protocol ResponseConvertable: Decodable {
    var apiErrorCode: String? { get }
    var isSuccess: Bool { get }
}
