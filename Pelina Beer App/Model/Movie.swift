//
//  Movie.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Mapper
import RealmSwift

final class Movie: Object, Mappable {
    
    @objc dynamic var title: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var overview: String = ""
    @objc dynamic var poster: String? = ""
    @objc  dynamic var voteAverage: Double = 0.0
    @objc dynamic var releaseDate: String = ""
    
    convenience init(map: Mapper) throws {
        self.init()
        try id = map.from("id")
        try title = map.from("title")
        try overview = map.from("overview")
        poster = map.optionalFrom("poster_path")
        try voteAverage = map.from("vote_average")
        try releaseDate = map.from("release_date")
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
}
