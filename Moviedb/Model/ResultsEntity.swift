//
//  ResultsEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class ResultsEntity{
    var key : String?
    init(dic : [String: Any]) {
        if let key = dic["key"] as? String{
            self.key = key
        }
    }
}
