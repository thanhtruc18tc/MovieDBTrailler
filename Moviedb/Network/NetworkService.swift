//
//  NetworkService.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import SwiftyJSON
import PromiseKit

protocol NetworkServiceProtocol {
    func requestObject<T: Codable> (endpoint: Endpoint) -> Promise<T>
    func requestArray<T: Codable> (endpoint: Endpoint) -> Promise<[T]>
}

class NetworkService: NetworkServiceProtocol {
    
    private let alamofireService: AlamofireService
    
    
    init(alamofireService: AlamofireService) {
        self.alamofireService = alamofireService
    }

    func requestObject<T: Codable> (endpoint: Endpoint) -> Promise<T> {
        return Promise<T> { (resolver) in
            
            self.alamofireService.request(endpoint: endpoint, success: { (data) in
                print(JSON(data))
                do {
                    let successResponse = try JSONDecoder().decode(T.self, from: data)
                    resolver.fulfill(successResponse)
                } catch {
                    resolver.reject(error)
                }
                
                
            }) { (error, data) in
                resolver.reject(ApiError(error: error))
            }
        }
    }
    
    func requestArray<T: Codable> (endpoint: Endpoint) -> Promise<[T]> {
        return Promise<[T]> { (resolver) in
            
            self.alamofireService.request(endpoint: endpoint, success: { (data) in
                print(JSON(data))
                do {
                   
                    let successResponse = try JSONDecoder().decode(SuccessResponse.Array<T>.self, from: data)
                    resolver.fulfill(successResponse.results)
                } catch {
                    resolver.reject(error)
                }
                
                
            }) { (error, data) in
                resolver.reject(ApiError(error: error))
            }
            

        }
        
        
    }
    
    
}

