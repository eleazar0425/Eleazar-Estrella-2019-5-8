//
//  Movie.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Mapper

final class Movie:  Mappable {
    
    var title: String
    var id: Int
    var overview: String
    var poster: String?
    var voteAverage: Double
    var releaseDate: String
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try title = map.from("title")
        try overview = map.from("overview")
        poster = map.optionalFrom("poster_path")
        try voteAverage = map.from("vote_average")
        try releaseDate = map.from("release_date")
    }
}
