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
    
    init(realm: Realm = try! Realm()){
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
        if movie.isInvalidated { return false }
        return realm.objects(Movie.self).contains(where: {
            if $0.isInvalidated { return false }
            return $0.id == movie.id //objects can change on the fly
            //consequently is better to validate this with de matched id
        })
    }
    
    func search(query: String, page: Int) -> Observable<Result<[Movie], String>> {
        let objects = realm.objects(Movie.self).filter { $0.title.contains(query)}
        var objectsArray = [Movie]()
        for object in objects {
            objectsArray.append(object)
        }
        
        return Observable.just(objectsArray)
            .asObservable()
            .map(Result.sucess)
    }
}
