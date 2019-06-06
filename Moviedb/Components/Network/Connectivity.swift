//
//  Connectivity.swift
//  Moviedb
//
//  Created by Truc Tran on 6/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
