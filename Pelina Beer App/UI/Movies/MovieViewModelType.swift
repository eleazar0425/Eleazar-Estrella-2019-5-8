//
//  MovieViewModelType.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol MovieViewModelType {
    
    var movies: Observable<[Movie]>! { get }
    
    var loadMore: BehaviorSubject<Bool>! { get }
    /// Call when an OrderBy value is invoked
    var orderByAction: Action<MovieOrderType, Void>! { get }
    /// Emits an OrderBy value when an OrderBy option is chosen.
    var orderBy: Observable<MovieOrderType>! { get }
    
    var movieDetailAction: Action<Movie, Void>! { get }
    
    var isRefreshing: Observable<Bool>! { get }
    
    func refresh()
    
    var searchString: BehaviorSubject<String?> { get }
}
