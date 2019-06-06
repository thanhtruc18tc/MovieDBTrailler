//
//  ControllCoreData.swift
//  Moviedb
//
//  Created by Truc Tran on 5/29/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
import CoreData
class Database {
    static let shared = Database()
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieData")
        container.loadPersistentStores(completionHandler: { (storeDesciption, error) in
            if let error = error{
                fatalError("Failed to load store : \(error)")
            }
        })
        return container
    }()
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    func saveMovieData(id : String, title : String, date : String, imgLink : String, voteAverage : Double){
//        let container = NSPersistentContainer(name: "MovieData")
//        container.loadPersistentStores { (storeDesciption, error) in
//            if let error = error{
//                fatalError("Failed to load store: \(error)")
//            }
//        }
//        let entity = NSEntityDescription.insertNewObject(forEntityName: "MyMovie", into: container.viewContext) as! Movie
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: persistentContainer.viewContext) as! Movie
        entity.id = id
        entity.data_release = date
        entity.poster_path = imgLink
        entity.title = title
        entity.vote_average = voteAverage
        saveContext()
    }
    func getMovieData() -> [Movie]{
        var result : [Movie]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        do{
            result = try persistentContainer.viewContext.fetch(request) as? [Movie]
            
        }catch{
            print("Failed")
        }
        return result ?? []
    }

    func deleteMovieDataByID(idMovie : Int){
        var result : [Movie]?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        do{
            var i = 0
            result = try persistentContainer.viewContext.fetch(request) as? [Movie]
            if let result = result{
                for film in result {
//                    print("id = \(idMovie) va ifDB = \(film.id)")
                    if idMovie == Int(film.id!) {
                        print("delete")
                        persistentContainer.viewContext.delete(film)
                    }
                    i += 1
                }
            }
        }catch{
            print("Failed")
        }
        saveContext()
    }
    func checkExist(idMovie : String) -> Bool{
        var exist = false
        let data = getMovieData().filter { (data) -> Bool in
                if idMovie == data.id{
                    exist = true
                    return  true
                }
                else{
                    return false
                }
            }
        return exist
    }
}
//request.returnsObjectsAsFaults = false
//do {
//    let result = try context.fetch(request)
//    for data in result as! [NSManagedObject] {
//        print(data.value(forKey: "username") as! String)
//    }
//
//} catch {
//
//    print("Failed")
//}

