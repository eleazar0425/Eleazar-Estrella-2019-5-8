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
    init(provider: MoyaProvider<MovieListingTarget> = MoyaProvider<MovieListingTarget>(plugins: [NetworkLoggerPlugin(verbose: false)])){
        self.provider = provider
    }
    
    func getMovies(page: Int, orderBy: MovieOrderType) -> Observable<Result<[Movie], String>> {
        var target: MovieListingTarget
        
        switch orderBy {
        case .name:
            target = .byName(page: page)
        case .year:
            target = .byYearDesc(page: page)
        case .rating:
            target = .topRated(page: page)
        }
        
        return provider.rx.request(target)
            .retry(2)
            .map(to: [Movie].self, keyPath: "results")
            .asObservable()
            .map(Result.sucess)
            .catchError{ .just(.error($0.localizedDescription)) }
    }
    
    func search(query: String, page: Int) -> Observable<Result<[Movie], String>> {
        return provider.rx.request(.search(query: query, page: page))
            .map(to: [Movie].self, keyPath: "results")
            .asObservable()
            .map(Result.sucess)
            .catchError{ .just(.error($0.localizedDescription)) }
    }
}
