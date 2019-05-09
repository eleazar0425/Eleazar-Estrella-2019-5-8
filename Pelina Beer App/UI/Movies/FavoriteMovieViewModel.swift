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

class FavoriteMovieViewModel: MovieViewModelType{
    var movies: Observable<[Movie]>!
    
    var loadMore: BehaviorSubject<Bool>!
    
    var orderByAction: Action<MovieOrderType, Void>!
    
    var orderBy: Observable<MovieOrderType>!
    
    var movieDetailAction: Action<Movie, Void>!
    
    var isRefreshing: Observable<Bool>!
    
    var service: MovieFavoriteService
    
    private let refreshProperty = BehaviorSubject<Bool>(value: true)
    private let orderByProperty = BehaviorSubject<MovieOrderType>(value: .rating)
    
    init(service: MovieFavoriteService = MovieFavoriteService()){
        self.service = service
        
        loadMore = BehaviorSubject(value: false)
        isRefreshing = refreshProperty.asObservable()
        orderBy = orderByProperty.asObservable()
        
        movies = service.getMovies(page: 0, orderBy: .rating)
            .flatMap { result -> Observable<[Movie]> in
                switch result {
                case let .sucess(movies):
                    return .just(movies)
                case .error(_):
                    return .empty()
                }
        }
    }
    
    func refresh() {
        
    }
}
