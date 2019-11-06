//
//  MovieAPI.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import PromiseKit

protocol MovieAPIProtocol {
    func getPopularMovie() -> Promise<[FilmEntity]>
    func getMovieDetail(id: Int) -> Promise<FilmDetails>
}

class MovieAPI: APIService, MovieAPIProtocol {

    func getPopularMovie() -> Promise<[FilmEntity]> {
        let endpoint = MovieEndPoint.getPopularMovie
        return network.requestArray(endpoint: endpoint)
    }
    
    func getMovieDetail(id: Int) -> Promise<FilmDetails> {
        let endpoint = MovieEndPoint.getMovieDetail(id: id)
        return network.requestObject(endpoint: endpoint)
    }
}
