//
//  MovieListingTarget.swift
//  Pelina Beer App
//
//  Created by Eleazar Estrella GB on 5/8/19.
//  Copyright © 2019 Eleazar Estrella. All rights reserved.
//

import Foundation
import Moya

enum MovieListingTarget {
    case topRatedMovies(page: Int)
}

extension MovieListingTarget: TargetType {
    
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL { return URL(string: AppConfig.BASE_MOVIE_DB_API_URL)!}
    
    var path: String {
        switch self {
        default:
            return "/discover/movie"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .topRatedMovies(let page):
            return .requestParameters(parameters:  [
                "sort_by" : "vote_average.desc",
                "page": page,
                "api_key": AppConfig.API_KEY
                ],
                                      encoding: URLEncoding.queryString)
        }
    }
}
