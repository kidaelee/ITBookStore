//
//  StoryBoardInstantiable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import UIKit

protocol StoryBoardInstantiable: AnyObject  {
    static var storyboardName: String { get }
}

extension StoryBoardInstantiable where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
