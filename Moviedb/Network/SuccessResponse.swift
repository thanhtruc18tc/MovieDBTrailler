//
//  SuccessResponse.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

struct SuccessResponse {
    
    struct Object<T: Codable>: Codable {
        let statusCode: Int?
        let data: T
        let message: String?
        
    }
    
    struct Array<T: Codable>: Codable {
//        struct Data: Codable {
//            let listItem: [T]
//            let total: Int?
//        }
        let statusCode: Int?
        let results: [T]
        let message: String?
    }
}
