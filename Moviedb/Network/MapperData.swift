////
////  MapperData.swift
////  Moviedb
////
////  Created by Henry on 11/5/19.
////  Copyright © 2019 Truc Tran. All rights reserved.
////
//
//import PromiseKit
//import SwiftyJSON
//
//protocol MapperDataProtocol {
//    func mapObject<T: Decodable> (data: Data) -> Promise<T>
//    func mapArray<T: Decodable> (data: Data) -> Promise<[T]>
//}
//
//class MapperData: MapperDataProtocol {
//    
//    func mapObject<T>(data: Data) -> Promise<T> where T : Decodable {
//        return Promise<T> { (resolver) in
//            do {
//                let successResponse = try JSONDecoder().decode(SuccessResponse.Object<T>.self, from: data)
//                resolver.fulfill(successResponse.data)
//            } catch {
//                resolver.reject(error)
//            }
//        }
//    }
//    
//    func mapArray<T>(data: Data) -> Promise<[T]> where T : Decodable {
//        return Promise<[T]> { (resolver) in
//            do {
//                let successResponse = try JSONDecoder().decode(SuccessResponse.Array<T>.self, from: data)
//                resolver.fulfill(successResponse.data.listItem)
//            } catch {
//                resolver.reject(error)
//            }
//        }
//    }
//}
