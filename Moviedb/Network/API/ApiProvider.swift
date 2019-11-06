//
//  APIProvider.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

class ApiProvider {
    
    static let shared: ApiProvider = ApiProvider()
    private let network: NetworkServiceProtocol
    
    var movieAPI: MovieAPIProtocol {
        return MovieAPI(network: network)
    }
    
    private init() {
        let alamofireService = AlamofireService()
        network = NetworkService(alamofireService: alamofireService)
    }
}
