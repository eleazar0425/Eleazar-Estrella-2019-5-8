//
//  MockService.swift
//  Pelina Beer AppTests
//
//  Created by Eleazar Estrella GB on 5/13/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Mapper
import RxSwift

@testable import Pelina_Beer_App

class MockService: MovieListingService {
    override func getMovies(page: Int, orderBy: MovieOrderType) -> Observable<Result<[Movie], String>> {
        
        var array = Array<Movie>()
        
        for i in 0..<20 {
            array.append(try! Movie(map: Mapper(JSON: ["id": 0, "title": "Movie \(page) - \(i)", "overview": "overview", "poster_path": "", "vote_average": 10.0, "release_date": "2019-1-1"])))
        }
        
        return Observable
                .just(array)
                .map(Result.sucess)
    }
    override func search(query: String, page: Int) -> Observable<Result<[Movie], String>> {
        var array = Array<Movie>()
        
        for i in 0..<20 {
            array.append(try! Movie(map: Mapper(JSON: ["id": 0, "title": "Searched Movie \(page) - \(i)", "overview": "overview", "poster_path": "", "vote_average": 10.0, "release_date": "2019-1-1"])))
        }
        return Observable
                .just(array)
                .map(Result.sucess)
    }
}
