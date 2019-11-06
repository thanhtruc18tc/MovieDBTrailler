//
//  AlamofireService.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Alamofire

final class AlamofireService {
    
    func request(endpoint: Endpoint, success: @escaping (Data) -> Void, failure: @escaping (Error, Data?) -> Void) {
        Alamofire.request(endpoint.path,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          encoding: URLEncoding.default,
                          headers: nil)
        .validate()
        .responseData { (responseData) in
            switch responseData.result {
                
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error, responseData.data)
            }
        }
    }
}
