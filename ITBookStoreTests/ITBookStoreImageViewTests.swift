//
//  ITBookStoreImageViewTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import Quick
import Nimble
import UIKit
@testable import ITBookStore

final class ITBookStoreImageViewTests: QuickSpec {
    struct MockImageDownloader: ImageDownloaderable {
        func downloadImage(with url: String, completion: @escaping (Data?) -> Void) -> Cancellable? {
            let image = UIImage(systemName: "heart.fill")
            let imageData = image?.jpegData(compressionQuality: 0.75)
            completion(imageData)
            
            return nil
        }
    }
    
    override func spec() {
        describe("UIImageView에서") {
            var imageView: UIImageView!
            var mockImageDownloader: ImageDownloaderable!
            beforeEach {
                imageView = UIImageView()
                mockImageDownloader = MockImageDownloader()
            }
            context("이미지를 다운로드 성공 하면") {
                beforeEach {
                    imageView.setImage(with: "test.jpg", imageDownloader: mockImageDownloader)
                }
                
                it("이미지가 할당 된다") {
                    expect(imageView.image).toNotEventually(beNil())
                }
                
                it("메모리에 이미지가 캐시된다") {
                    let memoryCache = UIImageMemoryCache.shared
                    expect(memoryCache.content(for:"test.jpg")).toNot(beNil())
                }
                
                it("디스크에 이미지가 캐시된다") {
                    let diskCache = DataDiskCache.default
                    expect(diskCache.content(for:"test.jpg")).toNot(beNil())
                }
            }
        }
    }
}
