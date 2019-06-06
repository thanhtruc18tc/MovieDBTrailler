//
//  CinemaEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/30/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class CinemaEntity {
    var cinema_id : String?
    var cinema_name : String?
    var cinema_image : String?
    var cinema_rate : Double?
    var cine_position : String?
    var cinema_address : String?
    var cinema_phone : String?
    var cinema_like : String?
    var cinema_link_book : String?
    var cinema_abb : String?
    init(dictionary : [String : Any]) {
        if let cinema_id = dictionary["cinema_id"] as? String{
            self.cinema_id = cinema_id
        }
        if let cinema_name = dictionary["cinema_name"] as? String{
            self.cinema_name = cinema_name
        }
        if let cinema_image = dictionary["cinema_image"] as? String{
            self.cinema_image = cinema_image
        }
        if let cinema_rate = dictionary["cinema_rate"] as? Double{
            self.cinema_rate = cinema_rate
        }
        if let cine_position = dictionary["cine_position"] as? String{
            self.cine_position = cine_position
        }
        if let cinema_address = dictionary["cinema_address"] as? String{
            self.cinema_address = cinema_address
        }
        if let cinema_phone = dictionary["cinema_phone"] as? String{
            self.cinema_phone = cinema_phone
        }
        if let cinema_like = dictionary["cinema_like"] as? String{
            self.cinema_like = cinema_like
        }
        if let cinema_link_book = dictionary["cinema_link_book"] as? String{
            self.cinema_link_book = cinema_link_book
        }
        if let cinema_abb = dictionary["cinema_abb"] as? String{
            self.cinema_abb = cinema_abb
        }
    }
}
