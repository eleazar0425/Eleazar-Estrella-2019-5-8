//
//  FavoriteMovieViewModel.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Action
import RxSwift

class FavoriteMovieViewModel: MovieViewModelType {
    
    var movies: Observable<[Movie]>!
    
    var loadMore: BehaviorSubject<Bool>!
    
    var orderBy: Observable<MovieOrderType>!
    
    var searchString: BehaviorSubject<String?>
    
    var isRefreshing: Observable<Bool>!
    
    var service: MovieFavoriteService
    
    lazy var orderByAction: Action<MovieOrderType, Void>! = {
        Action<MovieOrderType, Void> { orderby in
            self.orderByProperty.onNext(orderby)
            return .empty()
        }
    }()
    
    lazy var movieDetailAction: Action<Movie, Void>! = {
        Action<Movie, Void> { movie in
            self.coordinator.transition(to: .movieDetail(movie: movie))
            return .empty()
        }
    }()
    
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<MovieOrderType>(value: .rating)
    private let coordinator: Coordinator
    
    
    init(service: MovieFavoriteService = MovieFavoriteService(), coordinator: Coordinator? = HomeCoordinator.shared){
        self.service = service
        
        self.coordinator = coordinator!
        
        loadMore = BehaviorSubject(value: false)
        isRefreshing = refreshProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        searchString = BehaviorSubject<String?>(value: nil)
        
        movies = Observable.combineLatest(orderBy, searchString)
            .flatMapLatest { orderBy, searchString -> Observable<[Movie]> in
                guard let searchString = searchString, !searchString.isEmpty else {
                    return service.getMovies(page: 0, orderBy: orderBy)
                        .flatMap { result -> Observable<[Movie]> in
                            switch result {
                            case let .sucess(movies):
                                return .just(movies)
                            case .error(_):
                                return .empty()
                            }
                    }
                }
                
                return service.search(query: searchString, page: 0)
                    .flatMap{ result -> Observable<[Movie]> in
                        switch result {
                        case let .sucess(movies):
                            return .just(movies)
                        case .error(_):
                            return .empty()
                        }
                }
            }
    }
    
    func refresh() {
        
    }
}
