//
//  MovieFavoriteService.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class MovieFavoriteService: MovieFavoriteServiceType, MovieDataSource {
    
    var realm: Realm
    
    init(realm: Realm = AppConfig.realmInstance){
        self.realm = realm
    }
    
    
    func getMovies(page: Int, orderBy: MovieOrderType) -> Observable<Result<[Movie], String>> {
        var movies = realm.objects(Movie.self)
        
        switch orderBy{
        case .name:
            movies = movies.sorted(byKeyPath: "title", ascending: true)
        case .year:
            movies = movies.sorted(byKeyPath: "releaseDate", ascending: true)
        case .rating:
            movies = movies.sorted(byKeyPath: "voteAverage", ascending: false)
        }
        
       return Observable.collection(from: movies)
            .flatMap { result -> Observable<[Movie]> in
                var movieArray = [Movie]()
                for movie in result {
                    movieArray.append(movie)
                }
                return .just(movieArray)
            }.asObservable()
            .map(Result.sucess)
    }
    
    func saveFavorite(movie: Movie) -> Disposable {
        let movieObject: Movie = Movie(value: movie)
        return Observable.from([movieObject])
            .subscribe(Realm.rx.add(update: true))
    }
    
    func deleteFavorite(movie: Movie) -> Disposable {
        let movieObject = realm.objects(Movie.self).first(where: { $0.id == movie.id })
        return Observable.from(optional: movieObject)
            .subscribe(Realm.rx.delete())
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return realm.objects(Movie.self).contains(movie)
    }
}
