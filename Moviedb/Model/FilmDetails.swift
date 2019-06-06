//
//  FilmDetails.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
class FilmDetails {
    var budget : Int?
    var revenue : Int?
    var homepage : String?
    var title : String?
    var overview : String?
    var poster_path : String?
    var backdrop_path : String?
    var release_date : String?
    var runtime : Int?
    var vote_average :Double?
    // genre
    var genres : GenreEntity?
    
    init(dic : [String:Any]) {
        if let budget = dic["budget"] as? Int{
            self.budget = budget
        }
        if let revenue = dic["revenue"] as? Int{
            self.revenue = revenue
        }
        if let runtime = dic["runtime"] as? Int{
            self.runtime = runtime
        }
        if let homepage = dic["homepage"] as? String{
            self.homepage = homepage
        }
        if let title = dic["title"] as? String{
            self.title = title
        }
        if let overview = dic["overview"] as? String{
            self.overview = overview
        }
        if let poster_path = dic["poster_path"] as? String{
            self.poster_path = poster_path
        }
        if let backdrop_path = dic["backdrop_path"] as? String{
            self.backdrop_path = backdrop_path
        }
        if let release_date = dic["release_date"] as? String{
            self.release_date = release_date
        }
        if let vote_average = dic["vote_average"] as? Double{
            self.vote_average = vote_average
        }
        if let genres = dic["genres"] as? [[String: Any]] {
            self.genres = GenreEntity(arrDic: genres)
        }
    }
    
}
