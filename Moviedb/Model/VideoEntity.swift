//
//  VideoEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class VideoEntity {
    var id : Int?
    var key : String?
    var name : String?
    init(dic : [String : Any]) {
        if let id = dic["id"] as? Int{
            self.id = id
        }
        if let key = dic["key"] as? String{
            self.key = key
        }
        if let name = dic["name"] as? String{
            self.name = name
        }
    }
}
