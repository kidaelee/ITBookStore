//
//  ITBookStoreViewModelTests.swift
//  ITBookStoreTests
//
//  Created by Nick on 2021/12/26.
//

import Foundation
import Quick
import RxSwift
import RxTest
import Nimble
import RxNimble

@testable import ITBookStore

final class ITBookStoreViewModelTests: QuickSpec {
    var disposeBag = DisposeBag()
    
    override func spec() {
        describe("SearchTableViewModel에") {
            var searchTableViewModel: SearchTableViewModel!
            var scheduler: TestScheduler!
            var disposeBag: DisposeBag!
            var output: SearchTableViewModel.Output!
            var keywordSubject: PublishSubject<String>!
            
            beforeEach {
                searchTableViewModel = SearchTableViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                keywordSubject = PublishSubject<String>()
                output = searchTableViewModel.transform(input: .init(searchITBooks: keywordSubject.asObservable()))
            }
            
            context("test, test1 keywords를 stream 발행하면") {
                beforeEach {
                    scheduler.createColdObservable(
                        [.next(10, "test"),
                         .next(20, "test1")
                        ])
                        .bind(to: keywordSubject)
                        .disposed(by: disposeBag)
                }
                
                it("keyword story에서 [test, test1] event를 받는다") {
                    expect(output.recentlySearchKeyword).events(scheduler: scheduler, disposeBag: disposeBag)
                        .to(equal([
                            .next(0, []),
                            .next(10, ["test"]),
                            .next(20, ["test1", "test"])
                        ]))
                }
            }
        }
    }
}
