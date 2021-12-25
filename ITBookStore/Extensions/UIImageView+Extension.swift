//
//  UIImageView+Extension.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import Alamofire
import UIKit

extension UIImageView {
    private struct AssociatedKeys {
        static var downloadCancellable = "downloadCancellable"
    }
    
    var downloadCancellable: Cancellable? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.downloadCancellable) as? Cancellable)
        }
        
        set {
            guard let newValue = newValue as Cancellable? else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.downloadCancellable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(with url: String) {
        cancelImageRequest()
        
        let cancellable = AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["image/*"])
            .response { imageResponse in
                guard let data = imageResponse.data else { return }
                self.image = UIImage(data: data)
            }
        
        downloadCancellable = cancellable
    }
    
    func cancelImageRequest() {
        downloadCancellable?.cancel()
        downloadCancellable = nil
    }
}
