//
//  CastEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/24/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class CastEntity{
    var cast_id : Int?
    var character : String?
    var credit_id : String?
    var gender : Int?
    var id : Int?
    var name : String?
    var order : Int?
    var profile_path : String?
    init(dic :[String: Any]) {
        
            if let cast_id = dic["cast_id"] as? Int{
                self.cast_id = cast_id
            }
            if let character = dic["character"] as? String{
                self.character = character
            }
            if let credit_id = dic["credit_id"] as? String{
                self.credit_id = credit_id
            }
            if let gender = dic["gender"] as? Int{
                self.gender = gender
            }
            if let id = dic["id"] as? Int{
                self.id = id
            }
            if let name = dic["name"] as? String{
                self.name = name
            }
            if let order = dic["order"] as? Int{
                self.order = order
            }
            if let profile_path = dic["profile_path"] as? String{
                self.profile_path = profile_path
            }
            
        
    }
    
    
}
