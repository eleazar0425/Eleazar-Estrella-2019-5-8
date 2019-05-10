//
//  MovieDataSource.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieDataSource {
    func getMovies(page: Int, orderBy: MovieOrderType) -> Observable<Result<[Movie], String>>
    func search(query: String, page: Int) -> Observable<Result<[Movie], String>>
}
