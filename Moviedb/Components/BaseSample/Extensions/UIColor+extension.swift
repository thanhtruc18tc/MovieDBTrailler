//
//  UIColor+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    class var textColor: UIColor {
        return UIColor(hexString: "000000")
    }
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hexString: String) {
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let rColor = Int(color >> 16) & mask
        let gColor = Int(color >> 8) & mask
        let bColor = Int(color) & mask

        let red   = CGFloat(rColor) / 255.0
        let green = CGFloat(gColor) / 255.0
        let blue  = CGFloat(bColor) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    //R:G:B:W
    func toRGB() -> String {
        var value = ""
        if let components = self.cgColor.components {
            if components.count > 3 {
                let red = Int(components[0] * 255).toIntPositive()
                let green = Int(components[1] * 255).toIntPositive()
                let blue = Int(components[2] * 255).toIntPositive()

                value = "\(red):\(green):\(blue)"
            } else if components.count == 2 {
                if components[0] == 1 {
                    value = "255:255:255"
                } else {
                    value = "0:0:0"
                }
            }
        }

        return value
    }
}

extension Int {
    func toIntPositive() -> Int {
        if self >= 0 {
            return self
        }
        return 0 - self
    }

    var addDocCharacter: String {
        let num = self as NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")

        guard let currency = formatter.string(from: num) else { return ""}
        return currency.replacingOccurrences(of: "₫", with: "")
    }
}
