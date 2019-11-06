//
//  MovieEndPoint.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Alamofire

enum MovieEndPoint {
    case getPopularMovie
    case getHotMovie
    case getMovieDetail(id: Int)
}

extension MovieEndPoint: Endpoint {
    
    var path: String {
        switch self {
        case .getPopularMovie:
            return LinkAPI.apiFilm
        case .getHotMovie:
            return LinkAPI.apiFilmHot
        case .getMovieDetail(let id):
            return  "https://api.themoviedb.org/3/movie/\(id)?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        default:
            return [:]
        }
    }
}
