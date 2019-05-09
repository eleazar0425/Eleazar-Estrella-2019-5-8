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
            self.refresh()
            return .empty()
        }
    }()
    
    var orderBy: Observable<MovieOrderType>!
    var isRefreshing: Observable<Bool>!
    
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<MovieOrderType>(value: .rating)
    
    var currentPage = 1
    var service: MovieListingService
    private var moviesArray = [Movie]()
    
    ////Default initialization, so we can avoid a more complex DI mechanism but we're able to test correcty this viewModel
    init(service: MovieListingService = MovieListingService()){
        
        self.service = service
        
        loadMore = BehaviorSubject(value: false)
        isRefreshing = refreshProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        
        
        
        //let firstRequest = service.getMovies(page: currentPage, orderBy: .rating)
        
        let firstRequest = Observable.combineLatest(isRefreshing, orderBy)
            .flatMapLatest { isRefreshing, orderBy -> Observable<[Movie]> in
                guard isRefreshing else { return .empty() }
                return service.getMovies(page: self.currentPage, orderBy: orderBy)
            }
        
        /*let nextRequest = loadMore.flatMapLatest { loadMore -> Observable<[Movie]> in
            guard loadMore else { return .empty() }
            let movies = service.getMovies(page: self.currentPage, orderBy: .rating)
            self.currentPage+=1
            return movies
        }*/
        
        let nextRequest = Observable.combineLatest(loadMore, orderBy)
            .flatMapLatest { loadMore, orderBy -> Observable<[Movie]> in
                guard loadMore else { return .empty() }
                self.currentPage+=1
                let movies = service.getMovies(page: self.currentPage, orderBy: .rating)
                return movies
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
