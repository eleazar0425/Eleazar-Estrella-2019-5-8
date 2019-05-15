//
//  Pelina_Beer_AppTests.swift
//  Pelina Beer AppTests
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Quick
import Nimble

@testable import Pelina_Beer_App

class Pelina_Beer_AppTests: QuickSpec {
    
    override func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var mockService: MockService!
        var viewModel: MovieRemoteViewModel!
        var loadMore: TestableObservable<Bool>!
        var moviesObserver: TestableObserver<[Movie]>!
        
        describe("MoviewsPresentationSpec") {
            context("After viewModel is initialized") {
                beforeEach {
                    scheduler = TestScheduler(initialClock: 0)
                    disposeBag = DisposeBag()
                    mockService = MockService()
                    viewModel = MovieRemoteViewModel(service: mockService, coordinator: FakeCoordinator())
                    moviesObserver = scheduler.createObserver([Movie].self)
                    loadMore = scheduler.createColdObservable([
                        .next(100, true),
                        .next(200, true),
                        .next(300, true),
                        .next(400, true)
                        ])
                }
                
                context("after viewModel its created"){
                    beforeEach {
                        viewModel = MovieRemoteViewModel(service: mockService, coordinator: FakeCoordinator())
                    }
                    
                    it("should have loaded the first 20 elements"){
                        
                        viewModel.movies.bind(to: moviesObserver)
                            .disposed(by: disposeBag)
                        
                        expect(viewModel.currentPage).to(equal(1))
                        expect(moviesObserver.events.last?.value.element?.count).to(equal(20))
                    }
                    
                    it("should have loaded 4 more pages"){
                        loadMore.bind(to: viewModel.loadMore)
                            .disposed(by: disposeBag)
                        
                        viewModel.movies.bind(to: moviesObserver)
                            .disposed(by: disposeBag)
                        
                        scheduler.start()
                        expect(viewModel.currentPage).to(equal(5))
                        expect(moviesObserver.events.last?.value.element?.count).to(equal(100))
                    }
                    
                    it("should reset the page count and retreive search results"){
                        
                        loadMore.bind(to: viewModel.loadMore)
                            .disposed(by: disposeBag)
                        
                        viewModel.movies.bind(to: moviesObserver)
                            .disposed(by: disposeBag)
                        
                        viewModel.searchString.onNext("search query has been done")
                        
                        expect(viewModel.currentPage).to(equal(1))
                        expect(moviesObserver.events.last?.value.element?.count).to(equal(20))
                    }
                    
                    it("should load reset the page count and retreive new sorted results"){
                        
                        loadMore.bind(to: viewModel.loadMore)
                            .disposed(by: disposeBag)
                        
                        viewModel.movies.bind(to: moviesObserver)
                            .disposed(by: disposeBag)
                        
                        viewModel.orderByAction.execute(.year)
                        
                        expect(viewModel.currentPage).to(equal(1))
                        expect(moviesObserver.events.last?.value.element?.count).to(equal(20))
                    }
                }
            }
        }
    }
}
