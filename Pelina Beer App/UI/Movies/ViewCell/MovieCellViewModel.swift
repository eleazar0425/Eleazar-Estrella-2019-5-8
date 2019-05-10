//
//  MovieCellViewModel.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Action
import RxSwift

protocol MovieCellViewModelType {
    var isFavoriteAction: Action<Favorite, Void>! { get }
    
    var favoriteMovieOutput: Observable<Favorite>! { get }
    var movieAction: Action<Movie, Void>! { get }
}

class MovieCellViewModel: MovieCellViewModelType {
    lazy var isFavoriteAction: Action<Favorite, Void>! = {
        Action<Favorite, Void> { [unowned self] favorite in
            if favorite.isFavorite {
                self.service.saveFavorite(movie: favorite.movie)
            }else{
                self.service.deleteFavorite(movie: favorite.movie)
            }
            return .empty()
        }
    }()
    
    lazy var movieAction: Action<Movie, Void>! = {
        Action<Movie, Void> { [unowned self] movie in
            self.movieProperty.onNext(movie)
            return .empty()
        }
    }()
    
    var favoriteMovieOutput: Observable<Favorite>!
    
    var service: MovieFavoriteServiceType & MovieDataSource
    
    var movieProperty = PublishSubject<Movie>()
    
    init(service: MovieFavoriteServiceType & MovieDataSource = MovieFavoriteService()){
        self.service = service
        
        favoriteMovieOutput = Observable.combineLatest(movieProperty, service.getMovies(page: 0, orderBy: .name))
            .flatMapLatest({ [unowned self] movie, result -> Observable<Favorite> in
                let isFavorite = self.service.isFavorite(movie: movie)
                return .just(Favorite(movie: movie, isFavorite: isFavorite))
            })
    }
}
