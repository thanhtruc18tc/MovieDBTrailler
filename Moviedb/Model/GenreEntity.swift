//
//  GenreEntity.swift
//  Moviedb
//
//  Created by Truc Tran on 5/23/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
class GenreEntity{
    var name : String?
    init(arrDic :[[String: Any]]) {
        var temp  = ""
        for i in 0..<arrDic.count {
            if let genre = arrDic[i]["name"] as? String{
                //self.name.append(genre)
                temp = temp + genre
                
                if (i < arrDic.count - 1 ) {
                    temp = temp + ", "
                }
            }
        }
        self.name = temp
    }
}
