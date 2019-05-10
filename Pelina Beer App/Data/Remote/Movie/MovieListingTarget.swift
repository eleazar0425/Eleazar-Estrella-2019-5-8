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
    case topRated(page: Int)
    case byName(page: Int)
    case byYearDesc(page: Int)
    case byYearAsc(page: Int)
    case search(query: String, page: Int)
}

extension MovieListingTarget: TargetType {
    
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL { return URL(string: AppConfig.BASE_MOVIE_DB_API_URL)!}
    
    var path: String {
        switch self {
        case .search(_,_):
            return "/search/movie"
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
        case .topRated(let page):
            return .requestParameters(parameters:  [
                "sort_by" : "vote_average.desc",
                "page": page,
                "api_key": AppConfig.API_KEY
                ], encoding: URLEncoding.queryString)
        case .byName(let page):
            return .requestParameters(parameters: [
                "sort_by" : "title",
                "page" : page,
                "api_key": AppConfig.API_KEY
                ], encoding: URLEncoding.queryString)
        case .byYearAsc(let page):
            return .requestParameters(parameters: [
                "sort_by" : "release_date.asc",
                "page" : page,
                "api_key": AppConfig.API_KEY
                ], encoding: URLEncoding.queryString)
        case .byYearDesc(let page):
            return .requestParameters(parameters: [
                "sort_by" : "release_date.desc",
                "page" : page,
                "api_key": AppConfig.API_KEY
                ], encoding: URLEncoding.queryString)
        case let .search(query, page):
            return .requestParameters(parameters: [
                "query": query,
                "page" : page,
                "api_key": AppConfig.API_KEY
                ], encoding: URLEncoding.queryString)
        }
    }
}
