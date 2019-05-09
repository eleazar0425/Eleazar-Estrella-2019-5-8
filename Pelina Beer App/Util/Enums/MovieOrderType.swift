//
//  MovieOrderType.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation

enum MovieOrderType: Int, CaseIterable {
    case name = 0, year = 1 , rating = 2
    
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .rating:
            return "Rating"
        case .year:
            return "Year"
        }
    }
}
