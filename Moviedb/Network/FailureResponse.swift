//
//  FailureResponse.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

struct FailureResponse: Decodable {
    
    struct Error: Decodable {
        let code: Int
        let message: Message
    }
    
    struct Message: Decodable {
        let error: String
    }
    
    let status: Int
    let error: Error
    
}
