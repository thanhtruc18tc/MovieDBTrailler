//
//  LinkAPI.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
struct LinkAPI{
    static var apiFilmHeader = "https://api.themoviedb.org/3/discover/movie?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"

     static let apiFilmHot = "https://api.themoviedb.org/3/discover/movie?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"
    static let apiFilm = "https://api.themoviedb.org/3/movie/popular?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=1"
    static let apiSearchFilms = "https://api.themoviedb.org/3/search/movie?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&query=%@&page=1&include_adult=false"
    static let apiSearchMoreFilms = "https://api.themoviedb.org/3/search/movie?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&query=%@&page=%@&include_adult=false"
    
    static let apiAllPopularFilms = "https://api.themoviedb.org/3/movie/popular?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=%@"
    static let apiFilmCredits = "https://api.themoviedb.org/3/person/%@/movie_credits?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"
    static var apiNowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=1"
    static var apiPopularPeople = "https://api.themoviedb.org/3/person/popular?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=1"
    static var apiAllNowPlaying = "https://api.themoviedb.org/3/movie/now_playing?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=%@"
    static var apiAllPopularPeople = "https://api.themoviedb.org/3/person/popular?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US&page=%@"
    static let apiFilmDetails = "https://api.themoviedb.org/3/movie/%@/credits?api_key=c9238e9fff997ddc12fc76e3904e2618"
    static let apiTrailers = "https://api.themoviedb.org/3/movie/%@/videos?api_key=c9238e9fff997ddc12fc76e3904e2618&language=en-US"

    static var apiCinemaInHoChiMinh = "https://iosmoviedb.herokuapp.com/listcinema/sg.json"
    static var apiCinemaInHaNoi = "https://iosmoviedb.herokuapp.com/listcinema/hn.json"
    static var apiCinemaInDanang = "https://iosmoviedb.herokuapp.com/listcinema/danang.json"
    static var apiCinemaInCanTho = "https://iosmoviedb.herokuapp.com/listcinema/ct.json"
    static var apiCinemaInDongNai = "https://iosmoviedb.herokuapp.com/listcinema/dongnai.json"
    
    static var apiCinema = "https://iosmoviedb.herokuapp.com/listcinema/%@.json"


}
