//
//  ApiError.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation

struct ApiError: Error {
    
    var code: Int?
    var message: String
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    init(error: Error) {
        self.code = nil
        self.message = error.localizedDescription
    }
}
