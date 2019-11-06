//
//  APIServices.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

class APIService {
    
    let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
}
