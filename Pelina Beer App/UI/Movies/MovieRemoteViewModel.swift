//
//  MovieRemoteViewModel.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift

class MovieRemoteViewModel: MovieViewModelType {
    var movies: Observable<[Movie]>!
    var loadMore: BehaviorSubject<Bool>!
    var currentPage = 1
    var service: MovieListingService
    
    ////Default initialization, so we can avoid a more complex DI mechanism but we're able to test correcty this viewModel
    init(service: MovieListingService = MovieListingService()){
        
        var moviesArray = [Movie]()
        self.service = service
        
        loadMore = BehaviorSubject(value: false)
        
        let firstRequest = service.getMovies(page: currentPage, orderBy: .rating)
        
        let nextRequest = loadMore.flatMapLatest { loadMore -> Observable<[Movie]> in
            guard loadMore else { return .empty() }
            let movies = service.getMovies(page: self.currentPage, orderBy: .rating)
            self.currentPage+=1
            return movies
        }
        
        movies = Observable.merge(firstRequest, nextRequest)
            .map { movies -> [Movie] in
                for movie in movies {
                    moviesArray.append(movie)
                }
                return moviesArray
        }
    }
    
}
