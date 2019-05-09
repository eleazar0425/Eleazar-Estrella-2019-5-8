//
//  MovieFavoriteService.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieFavoriteServiceType {
    @discardableResult func saveFavorite(movie: Movie) -> Disposable
    @discardableResult func deleteFavorite(movie: Movie) -> Disposable
    func isFavorite(movie: Movie) -> Bool
}
