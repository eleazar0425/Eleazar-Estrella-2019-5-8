//
//  MovieDetailViewModel.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/10/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Action
import RxSwift

protocol MovieDetailViewModelType {
    var isFavoriteAction: Action<Favorite, Void>! { get }
}


class MoviewDEtailViewModelType: MovieDetailViewModelType {
    
    lazy var isFavoriteAction: Action<Favorite, Void>! = {
        Action<Favorite, Void> { [unowned self] favorite in
            if favorite.isFavorite{
                self.service.saveFavorite(movie: favorite.movie)
                    .disposed(by: self.disposeBag)
            }else{
                self.service.deleteFavorite(movie: favorite.movie)
                    .disposed(by: self.disposeBag)
            }
            return .empty()
        }
    }()
    
    var service: MovieFavoriteService
    
    var disposeBag = DisposeBag()
    
    init(service: MovieFavoriteService = MovieFavoriteService()){
        self.service = service
    }
    
}
