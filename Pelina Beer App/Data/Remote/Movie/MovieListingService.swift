//
//  MovieListingServie.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ModelMapper


class MovieListingService: MovieDataSource {
    
    var provider: MoyaProvider<MovieListingTarget>
    
    //Default initialization, so we can avoid a more complex DI mechanism but we're able to test correcty this service
    init(provider: MoyaProvider<MovieListingTarget> = MoyaProvider<MovieListingTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])){
        self.provider = provider
    }
    
    func getMovies(page: Int, orderBy: MovieOrderType) -> Observable<[Movie]> {
        //Ignore orderByType by now
        return provider.rx.request(.topRatedMovies(page: page))
            .retry(2)
            .map(to: [Movie].self, keyPath: "results")
            .asObservable()
    }
}
