////
////  PeopleEndPoint.swift
////  Moviedb
////
////  Created by Henry on 11/5/19.
////  Copyright © 2019 Truc Tran. All rights reserved.
////
//
//import Alamofire
//
//enum PeopleEndPoint {
//    case getMovie
//    case getHotMovie
//}
//
//extension PeopleEndPoint: Endpoint {
//
//    var path: String {
//        switch self {
//        case .getPopularMovie:
//            return LinkAPI.apiFilm
//        case .getHotMovie:
//            return LinkAPI.apiFilmHot
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        default:
//            return .get
//        }
//    }
//
//    var parameters: [String : Any] {
//        switch self {
//        default:
//            return [:]
//
//        }
//    }
//}
