//
//  Movie+CoreDataProperties.swift
//  Moviedb
//
//  Created by Truc Tran on 5/29/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var data_release: String?
    @NSManaged public var vote_average: Double
    @NSManaged public var id: String?

}
