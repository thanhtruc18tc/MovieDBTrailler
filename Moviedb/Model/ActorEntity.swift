//
//  ActorEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/24/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class ActorEntity {
    var id : Int?
    var birthday : String?
    var known_for_department : String?
    var name : String?
    var place_of_birth : String?
    var profile_path : String?
    var biography : String?
    init(dic :[String: Any]) {
        if let id = dic["id"] as? Int{
            self.id = id
        }
        if let birthday = dic["birthday"] as? String{
            self.birthday = birthday
        }
        if let known_for_department = dic["known_for_department"] as? String{
            self.known_for_department = known_for_department
        }
        if let name = dic["name"] as? String{
            self.name = name
        }
        if let place_of_birth = dic["place_of_birth"] as? String{
            self.place_of_birth = place_of_birth
        }
        if let profile_path = dic["profile_path"] as? String{
            self.profile_path = profile_path
        }
        if let biography = dic["biography"] as? String{
            self.biography = biography
        }
    }
}
