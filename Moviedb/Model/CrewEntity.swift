//
//  CrewEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/24/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class  CrewEntity {
    var department : String?
    var credit_id : String?
    var gender : Int?
    var id : Int?
    var name : String?
    var job : String?
    var profile_path : String?
    init(dic :[[String: Any]]) {
        for element in dic{
            if let department = element["department"] as? String{
                self.department = department
            }
            if let credit_id = element["credit_id"] as? String{
                self.credit_id = credit_id
            }
            if let gender = element["gender"] as? Int{
                self.gender = gender
            }
            if let id = element["id"] as? Int{
                self.id = id
            }
            if let name = element["name"] as? String{
                self.name = name
            }
            if let job = element["job"] as? String{
                self.job = job
            }
            if let profile_path = element["profile_path"] as? String{
                self.profile_path = profile_path
            }
            
        }
    }
   
}
