//
//  MovieRemoteViewModel.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift
import Action

class MovieRemoteViewModel: MovieViewModelType {
    
    var movies: Observable<[Movie]>!
    var loadMore: BehaviorSubject<Bool>!
    
    lazy var orderByAction: Action<MovieOrderType, Void>! = {
        Action<MovieOrderType, Void> { orderby in
            self.orderByProperty.onNext(orderby)
            self.refresh()
            return .empty()
        }
    }()
    
    lazy var movieDetailAction: Action<Movie, Void>! = {
        Action<Movie, Void> { movie in
            self.coordinator.transition(to: .movieDetail(movie: movie))
            return .empty()
        }
    }()
    
    var orderBy: Observable<MovieOrderType>!
    var isRefreshing: Observable<Bool>!
    
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<MovieOrderType>(value: .rating)
    
    var currentPage = 1
    var service: MovieListingService
    var coordinator: Coordinator
    private var moviesArray = [Movie]()
    
    ////Default initialization, so we can avoid a more complex DI mechanism but we're able to test correcty this viewModel
    init(service: MovieListingService = MovieListingService(), coordinator: Coordinator? = HomeCoordinator.shared){
        
        self.service = service
        self.coordinator = coordinator!
        
        loadMore = BehaviorSubject(value: false)
        
        isRefreshing = refreshProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        
        let firstRequest = Observable.combineLatest(isRefreshing, orderBy)
            .flatMapLatest { isRefreshing, orderBy -> Observable<[Movie]> in
                guard isRefreshing else { return .empty() }
                return service.getMovies(page: self.currentPage, orderBy: orderBy)
                    .flatMap({ [unowned self] result -> Observable<[Movie]> in
                        switch result{
                        case let .sucess(movies):
                            return .just(movies)
                        case let .error(error):
                            coordinator?.presentSimpleDialog(alertViewModel: AlertViewModel(message: error, title: "Ups..."))
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                    })
            }

        let nextRequest = Observable.combineLatest(loadMore, orderBy)
            .flatMapLatest { loadMore, orderBy -> Observable<[Movie]> in
                guard loadMore else { return .empty() }
                self.currentPage+=1
                return service.getMovies(page: self.currentPage, orderBy: orderBy)
                    .flatMap { [unowned self] result -> Observable<[Movie]> in
                        switch result{
                        case let .sucess(movies):
                            return .just(movies)
                        case let .error(error):
                            coordinator?.presentSimpleDialog(alertViewModel: AlertViewModel(message: error, title: "Ups..."))
                            self.refreshProperty.onNext(false)
                            return .empty()
                        }
                }
        }
        
        movies = Observable.merge(firstRequest, nextRequest)
            .map { movies -> [Movie] in
                for movie in movies {
                    self.moviesArray.append(movie)
                }
                self.refreshProperty.onNext(false)
                return self.moviesArray
        }
    }
    
    func refresh() {
        self.moviesArray = []
        self.currentPage = 1
        self.refreshProperty.onNext(true)
    }
    
}
