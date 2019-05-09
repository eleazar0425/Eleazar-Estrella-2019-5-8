//
//  Favorite.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
class Favorite {
    var movie: Movie
    var isFavorite: Bool
    
    init(movie: Movie, isFavorite: Bool){
        self.movie = movie
        self.isFavorite = isFavorite
    }
}
