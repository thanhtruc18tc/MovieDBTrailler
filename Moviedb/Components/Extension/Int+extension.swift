//
//  Int+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit
import ObjectMapper
postfix operator *

postfix func *<T>(element: T?) -> Int {
    return (element == nil) ? 0: Int("\(element!)")!
}

extension Float {
    /// Rounds the double to decimal places value
    func roundedTwoDemical() -> String {
        return String(format: "%.2f", self)
    }
}

extension CGFloat {
    func toInt() -> Int {
        let intValue = Int(self)
        let mod = self - CGFloat(intValue)

        if mod > 0.5 {
            return intValue + 1
        } else {
            return intValue
        }
    }
}

public extension Double {

    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }

    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }

}


class StringToIntTransform: TransformType {
    public typealias Object     = Int
    public typealias JSON       = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Int? {
        if let timeStr = value as? String {
            return Int(timeStr)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Int?) -> String? {
        if let intValue = value {
            return intValue.description
        }
        return nil
    }
}

class IntToStringTransform: TransformType {
    public typealias Object     = String
    public typealias JSON       = Int
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> String? {
        if let timeStr = value as? Int {
            return String(timeStr)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: String?) -> Int? {
        if let intValue = value {
            return Int(intValue)
        }
        return nil
    }
}


extension Int {
    func convertMilisecondsToTime() -> String {
        let hour : Int = self / 3600
        let min = (self - hour * 3600)/60
        let milisecond = self  % 60
        return "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(min < 10 ? "0\(min)" : "\(min)"):\(milisecond < 10 ? "0\(milisecond)" : "\(milisecond)")"
    }
}
class StringToDoubleTransform: TransformType {
    public typealias Object     = Double
    public typealias JSON       = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Double? {
        if let timeStr = value as? String {
            return Double(timeStr)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Double?) -> String? {
        if let intValue = value {
            return intValue.description
        }
        return nil
    }
}
