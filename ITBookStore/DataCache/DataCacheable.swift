//
//  ImageCacheable.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/25.
//

import Foundation
import UIKit

protocol Cacheable {
    associatedtype Content

    func content(for key: String) -> Content?
    func add(with key: String, content: Content)
    func remove(with key: String)
    func removeall()
}

final class UIImageMemoryCache: Cacheable {
    static let shared = UIImageMemoryCache()
    
    @Atomic private var cache: NSCache = NSCache<NSString, UIImage>()
    
    func content(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func add(with key: String, content: UIImage) {
        _cache.mutate {
            $0.setObject(content, forKey: key as NSString)
        }
    }
    
    func remove(with key: String) {
        _cache.mutate {
            $0.removeObject(forKey: key as NSString)
        }
    }
    
    func removeall() {
        _cache.mutate {
            $0.removeAllObjects()
        }
    }
}

final class DataDiskCache: Cacheable {
    private let filemanager = FileManager()
    private let cachePath: URL
    
    init(cachePath: URL) {
        self.cachePath = cachePath
    }
    
    static var `default`: DataDiskCache {
        let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return DataDiskCache(cachePath: cachePath)
    }
    
    func content(for key: String) -> Data? {
        try? Data(contentsOf: dataPathUrl(with: key))
    }
    
    func add(with key: String, content: Data) {
        if !filemanager.fileExists(atPath: cachePath.path) {
            try? filemanager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        }
        
        try? content .write(to: dataPathUrl(with: key))
    }
    
    func remove(with key: String) {
        if filemanager.fileExists(atPath: dataPath(with: key)) {
            try? filemanager.removeItem(atPath: dataPath(with: key))
        }
    }
    
    func removeall() {
        try? filemanager.removeItem(at: cachePath)
        try? filemanager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func dataPathUrl(with key: String) -> URL {
        cachePath.appendingPathComponent(key)
    }
    
    private func dataPath(with key: String) -> String {
        dataPathUrl(with: key).path
    }
}
