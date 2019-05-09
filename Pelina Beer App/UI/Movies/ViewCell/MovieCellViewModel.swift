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
    
    var service: MovieFavoriteServiceType
    
    private let favoriteProperty = BehaviorSubject<Bool>(value: false)
    
    init(service: MovieFavoriteServiceType = MovieFavoriteService()){
        self.service = service
    }
}
