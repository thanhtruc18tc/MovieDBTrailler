//
//  APIManager.swift
//  Moviedb
//
//  Created by Truc Tran on 6/6/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit
import Alamofire
class APIManager {
    
    class func showAlert(){
        let alert = UIAlertController(title: "No internet connection!", message: "Please connect the internet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func getCinema(urlString: String, completion: @escaping ([CinemaEntity]) -> Void) {
        if Connectivity.isConnectedToInternet(){
            var cinemas = [CinemaEntity]()
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                if response.result.isSuccess{
                    if let dic = response.result.value as? [String: Any]{
                        if let results = dic["data"] as? [[String : Any]]{
                            for result in results{
                                let cinema = CinemaEntity(dictionary: result)
                                cinemas.append(cinema)
                            }
                        }
                    }
                    completion(cinemas)
                }else if response.result.isFailure, let error = response.result.error{
                    print(error)
                }
            }
        }else{
            showAlert()
        }
  
    }
    
    class func getPopularMovies(urlString: String, completion: @escaping ([FilmEntity]) -> Void){
            var listPopularMovies = [FilmEntity]()
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                if response.result.isSuccess{
                    if let responeValue = response.result.value as? [String: Any]{
                        if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                            for dic in listDictFilm {
                                let film = FilmEntity(dictionary: dic)
                                listPopularMovies.append(film)
                            }
                        }
                    }
                completion(listPopularMovies)
                }else if let error = response.result.error{
                    print(error)
                }
            }
        
    }
    
    class func getNowPlayingMovies(urlString: String, completion: @escaping ([FilmEntity]) -> Void){
        
            var listNowPlayingMovies = [FilmEntity]()
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                if response.result.isSuccess{
                    if let responeValue = response.result.value as? [String: Any]{
                        if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                            for dic in listDictFilm {
                                let film = FilmEntity(dictionary: dic)
                                listNowPlayingMovies.append(film)
                            }
                        }
                    }
                completion(listNowPlayingMovies)
                }else if let error = response.result.error{
                    print(error)
                }
            }
    }
    class func getPopularPeople(urlString: String, completion: @escaping ([ActorEntity]) -> Void){
        var listPopularPeople = [ActorEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let actor = ActorEntity(dic: dic)
                            listPopularPeople.append(actor)
                        }
                    }
                }
            completion(listPopularPeople)
            }else if let error = response.result.error{
                print(error)
            }
        }
    }
    class func getVideo(urlString: String, completion: @escaping ([VideoEntity]) -> Void){
        var listVideo = [VideoEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let results = dic["results"] as? [[String : Any]]{
                        for video in results{
                            let video = VideoEntity(dic: video)
                            listVideo.append(video)
                        }
                    }
                }
            completion(listVideo)
            }else if let error = response.result.error{
                print(error)
            }
        }
    }
    class func getDetailFilmFromAPI(urlString: String, completion: @escaping (FilmDetails) -> Void){
        if Connectivity.isConnectedToInternet(){
            var filmDetails : FilmDetails!
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                
                if response.result.isSuccess{
                    if let dic = response.result.value as? [String: Any]{
                        let film = FilmDetails(dic: dic)
                        filmDetails = film
                    }
                    completion(filmDetails)
                }else if let error = response.result.error{
                    print(error)
                }
            }
        }else{
            showAlert()
        }
   
    }
    class func getPeopleDetail(urlString: String, completion: @escaping (ActorEntity) -> Void){
        if Connectivity.isConnectedToInternet(){
            var actorDetail : ActorEntity!
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                
                if response.result.isSuccess{
                    if let dic = response.result.value as? [String: Any]{
                        let actor = ActorEntity(dic: dic)
                        actorDetail = actor
                    }
                    completion(actorDetail)
                }else if let error = response.result.error{
                    print(error)
                }
            }
        }else{
            showAlert()
        }
        
        
    }
    class func getFilmCredits(urlString: String, completion: @escaping ([FilmEntity]) -> Void){
        var listFilmCredits = [FilmEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["cast"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let film = FilmEntity(dictionary: dic)
                            listFilmCredits.append(film)
                        }
                    }
                }
                
                completion(listFilmCredits)
            }else if let error = response.result.error{
                print(error)
            }
        }
        
    }
    class func searchFilms(urlString: String, completion: @escaping ([FilmEntity]) -> Void){
        var listFilmFound = [FilmEntity]()
        if Connectivity.isConnectedToInternet(){
            Alamofire.request(urlString, method: .get).responseJSON { (response) in
                if response.result.isSuccess{
                    if let dic = response.result.value as? [String: Any]{
                        if let results = dic["results"] as? [[String : Any]]{
                            for result in results{
                                let film = FilmEntity(dictionary: result)
                                listFilmFound.append(film)
                            }
                        }
                        
                    }
                    completion(listFilmFound)
                }else if let error = response.result.error{
                    print(error)
                }
            }
        }
        else{
            showAlert()
        }
    }
    //get actor for film details
    class func getPeopleForFilmDetail(urlString: String, completion: @escaping ([CastEntity]) -> Void){
        var listActor = [CastEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: Any]{
                    if let cast = dic["cast"] as? [[String : Any]]{
                        for element in cast{
                            let actor = CastEntity(dic: element)
                            listActor.append(actor)
                        }
                    }
                }
                completion(listActor)
            }else if let error = response.result.error{
                print(error)
            }
        }
    }
    class func loadMoreFilms(urlString: String, completion: @escaping ([FilmEntity]) -> Void){
        var listFilms = [FilmEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let film = FilmEntity(dictionary: dic)
                            listFilms.append(film)
                        }
                    }
                }
                completion(listFilms)
            }else if let error = response.result.error{
                print(error)
            }
        }
    }
    class func loadMorePeople(urlString: String, completion: @escaping ([ActorEntity]) -> Void){
        var listPeople = [ActorEntity]()
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                if let responeValue = response.result.value as? [String: Any]{
                    if let listDictFilm = responeValue["results"] as? [[String: Any]]{
                        for dic in listDictFilm {
                            let actor = ActorEntity(dic: dic)
                            listPeople.append(actor)
                        }
                    }
                }
                completion(listPeople)
            }else if let error = response.result.error{
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
}
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
