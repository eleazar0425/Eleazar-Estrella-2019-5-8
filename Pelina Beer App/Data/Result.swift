//
//  Result.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/9/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation

enum Result<T, E> {
    case sucess(T)
    case error(E)
}
