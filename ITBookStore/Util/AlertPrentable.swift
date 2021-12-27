//
//  AlertPrentable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/28.
//

import Foundation
import UIKit

protocol AlsertPresentable {
    func presentDefaultAlert(with title: String, message: String)
}

extension AlsertPresentable where Self: UIViewController {
    func presentDefaultAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
}
