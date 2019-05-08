//
//  MovieViewModelType.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import RxSwift

protocol MovieViewModelType {
    var movies: Observable<[Movie]>! { get }
    var loadMore: BehaviorSubject<Bool>! { get }
}
