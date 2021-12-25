//
//  UIImageView+Extension.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import Alamofire
import UIKit


protocol ImageDownloaderable {
    func downloadImage(with url: String, completion: @escaping (Data?) -> Void) -> Cancellable?
}

struct DefaultImageDownloader: ImageDownloaderable {
    func downloadImage(with url: String, completion: @escaping (Data?) -> Void) -> Cancellable? {
        let cancellable = AF.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["image/*"])
            .response { imageResponse in
                completion(imageResponse.data)
            }
        
        return cancellable
    }
}

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
    
    func setImage(with url: String, imageDownloader: ImageDownloaderable? = DefaultImageDownloader()) {
        cancelImageRequest()
        self.image = nil
        
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        let cacheKey = imageUrl.lastPathComponent
        
        if let image = UIImageMemoryCache.shared.content(for: cacheKey) {
            self.image = image
            return
        }
        
        if let imageData = DataDiskCache.default.content(for: cacheKey), let image = UIImage(data: imageData) {
            UIImageMemoryCache.shared.add(with: cacheKey, content: image)
            self.image = image
            return
        }
        
        let cancellable = imageDownloader?.downloadImage(with: url, completion: { imageData in
            guard let data = imageData, let image = UIImage(data: data) else { return }

            UIImageMemoryCache.shared.add(with: cacheKey, content: image)
            DataDiskCache.default.add(with: cacheKey, content: data)

            self.image = image

        })
        
        downloadCancellable = cancellable
    }
    
    func cancelImageRequest() {
        downloadCancellable?.cancel()
        downloadCancellable = nil
    }
}
