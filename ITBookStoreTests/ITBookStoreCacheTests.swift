//
//  ITBookStoreCacheTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import UIKit
import Quick
import Nimble

@testable import ITBookStore

class ITBookStoreMemoryCacheTests: QuickSpec {
    override func spec() {
        
        var memoryCache: UIImageMemoryCache!
        let queue1 = DispatchQueue(label: "1")
        let queue2 = DispatchQueue(label: "2")
        
        describe("메모리 캐시에서") {
            beforeEach {
                memoryCache = UIImageMemoryCache()
            }
            
            context("서로 다른 쓰레드에서 이미지 200개를 넣는다.") {
                beforeEach {
                    waitUntil { done in
                        queue1.async {
                            for key in 1...100 {
                                memoryCache.add(with: "\(key)", content: UIImage())
                            }
                            done()
                        }
                    }
                    
                    waitUntil { done in
                        queue2.async {
                            for key in 101...200 {
                                memoryCache.add(with: "\(key)", content: UIImage())
                            }
                            done()
                        }
                    }
                }
                
                it("200개의 이미지가 있어야 한다") {
                    var count = 0
                    for key in 1...200 {
                        if let _ = memoryCache.content(for: "\(key)") {
                            count += 1
                        }
                    }
                    
                    expect(count).to(equal(200))
                }
            }
            
            context("10개의 이미지중 하나를 지우면") {
                beforeEach {
                    for key in 1...10 {
                        memoryCache.add(with: "\(key)", content: UIImage())
                    }
                    
                    memoryCache.remove(with: "1")
                }
                
                it("9개가 있어야 한다") {
                    var count = 0
                    for key in 1...10 {
                        if let _ = memoryCache.content(for: "\(key)") {
                            count += 1
                        }
                    }
                    
                    expect(count).to(equal(9))
                }
                
            }
            
            context("10개의 이미지를 모두 지우면") {
                beforeEach {
                    for key in 1...10 {
                        memoryCache.add(with: "\(key)", content: UIImage())
                    }
                    
                    memoryCache.removeall()
                }
                
                it("0개가 있어야 한다") {
                    var count = 0
                    for key in 1...10 {
                        if let _ = memoryCache.content(for: "\(key)") {
                            count += 1
                        }
                    }
                    
                    expect(count).to(equal(0))
                }
            }
        }
    }
}

class ITBookStoreDiskCacheTests: QuickSpec {
    override func spec() {
        var diskCache: DataDiskCache!
        describe("Disk cache에서") {
            beforeEach {
                let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                diskCache = DataDiskCache(cachePath: cacheUrl)
            }
            
            context("data 하나를 추가한다.") {
                beforeEach {
                    let string = "Test"
                    diskCache.add(with: "aaaa", content: string.data(using: .utf8)!)
                }
                
                it("캐시폴더에 하나가 있어야 한다") {
                    guard let data = diskCache.content(for: "aaaa") else {
                        fail()
                        return
                    }
                    let str = String(data: data, encoding: .utf8)
                    expect(str).to(equal("Test"))
                }
            }
            
            context("data 하나를 추가 후 삭제한다.") {
                beforeEach {
                    let string = "Test"
                    diskCache.add(with: "bbbb", content: string.data(using: .utf8)!)
                    diskCache.remove(with: "bbbb")
                }
                
                it("캐시폴더에 없어야 한다") {
                    expect(diskCache.content(for: "bbbb")).to(beNil())
                }
            }
            
            context("data 3개를 추가 후 모두 삭제한다.") {
                beforeEach {
                    let string = "Test"
                    
                    for key in 1...3 {
                        diskCache.add(with: "\(key)", content: string.data(using: .utf8)!)
                    }
                    
                    diskCache.removeall()
                }
                
                it("캐시폴더에 없어야 한다") {
                    var count = 0
                    for key in 1...3 {
                        if let _ = diskCache.content(for: "\(key)") {
                            count += 1
                        }
                    }
                    
                    expect(count).to(equal(0))
                }
            }
        }
    }
}
