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
import Mapper

@testable import Pelina_Beer_App

class Pelina_Beer_AppTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockService: MockService!
    var viewModel: MovieRemoteViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.mockService = MockService()
        self.viewModel = MovieRemoteViewModel(service: mockService, coordinator: FakeCoordinator())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.scheduler = nil
        self.disposeBag = nil
        self.mockService = nil
        self.viewModel = nil
    }

    func testViewModelShouldCallForMoreMovies(){
        let loadMore = scheduler.createColdObservable([
            .next(100, true),
            .next(200, true),
            .next(300, true),
            .next(400, true)
            ])
        
        loadMore.bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        
        let moviesObserver = scheduler.createObserver([Movie].self)
        
        viewModel.movies.bind(to: moviesObserver)
            .disposed(by: disposeBag)
        
        assert(moviesObserver.events.last!.time == 400)
        let movies = moviesObserver.events.last!.value.element!
        assert(movies.count == 5)
    }
    
    func testViewModelShouldResetPageCountWhenSearchIsExcuted(){
        let loadMore = scheduler.createColdObservable([
            .next(100, true),
            .next(200, true),
            .next(300, true),
            .next(400, true)
            ])
        
        loadMore.bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        let searchString = "search query"
        viewModel.searchString.onNext(searchString)
        
        assert(viewModel.currentPage == 1)
        
    }
    
    func testViewModelShouldRefreshModelWhenSearchIsExecuted(){
        let loadMore = scheduler.createColdObservable([
            .next(100, true),
            .next(200, true),
            .next(300, true),
            .next(400, true)
            ])
        
        loadMore.bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        viewModel.searchString.onNext("First query")
        
        let moviesObserver = scheduler.createObserver([Movie].self)
        
        viewModel.movies.bind(to: moviesObserver)
            .disposed(by: disposeBag)
        
        let movies = moviesObserver.events.last!.value.element!
        
        assert(movies.count == 1)
        
    }
}
