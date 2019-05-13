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
        return
            Observable
                .just([try! Movie(map: Mapper(JSON: ["id": 0, "title": "Movie \(page)", "overview": "overview", "poster_path": "", "vote_average": 10.0, "release_date": "2019-1-1"]))])
                .map(Result.sucess)
    }
    override func search(query: String, page: Int) -> Observable<Result<[Movie], String>> {
        return
            Observable
                .just([try! Movie(map: Mapper(JSON: ["id": 0, "title": "Movie 1", "overview": "overview", "poster_path": "", "vote_average": 10.0, "release_date": "2019-1-1"]))])
                .map(Result.sucess)
    }
}
