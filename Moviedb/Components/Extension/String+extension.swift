//
//  String+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import SystemConfiguration
import CommonCrypto

postfix operator &
//let CCSHA256DIGESTLENGTH   =  32

postfix func & <T>(element: T?) -> String {
    return (element == nil) ? "" : "\(element!)"
}

postfix func & <T>(element: T) -> String {
    return "\(element)"
}

extension String {

    func htmlDecoded() -> String {

        guard (self != "") else { return self }

        var newStr = self
        // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&deg;": "º"
        ]

        for (name, value) in entities {
            newStr = newStr.replacingOccurrences(of: name, with: value)
        }
        return newStr
    }

    func htmlEncoded() -> String {

        guard (self != "") else { return self }

        var newStr = self
        // from https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
        let entities = [ //a dictionary of HTM/XML entities.
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&deg;": "º"
        ]

        for (name, value) in entities {
            newStr = newStr.replacingOccurrences(of: value, with: name)
        }
        return newStr
    }

    func isValidEmpty() -> Bool {
        if self.cutWhiteSpace().isEmpty {
            return true
        }
        return (self.cutWhiteSpace().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "")
    }

    func cutWhiteSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func toDouble() -> Double {
        let nsString = self as NSString
        return nsString.doubleValue
    }
}

// MARK: validate
extension String {
    func phoneString() -> String? {
        return self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }

//    func sha256Ma() -> String {
//        if let stringData = self.data(using: String.Encoding.utf8) {
//            return hexStringFromData(input: digest(input: stringData as NSData))
//        }
//        return ""
//    }
//
//    private func digest(input: NSData) -> NSData {
//        let digestLength = Int(CCSHA256DIGESTLENGTH)
//        var hash = [UInt8](repeating: 0, count: digestLength)
//        //        CC_SHA256(input.bytes, UInt32(input.length), &hash)
//        return NSData(bytes: hash, length: digestLength)
//    }
//
//    private  func hexStringFromData(input: NSData) -> String {
//        var bytes = [UInt8](repeating: 0, count: input.length)
//        input.getBytes(&bytes, length: input.length)
//
//        var hexString = ""
//        for byte in bytes {
//            hexString += String(format: "%02x", UInt8(byte))
//        }
//
//        return hexString
//    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func isEmptyIgnoreNewLine() -> Bool {
        return self.trim().isEmpty
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func isVietNamese() -> Bool {
        let listVietNamese = "ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ"
        let listResult =  self.filter {listVietNamese.contains($0)}
        return listResult.count > 0 ? false : true
    }

    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9 _ .].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: self.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }

    func isValidPhone() -> Bool {
        let emailRegEx = "^(1\\-)?[0][0-9]{2,3}\\-?[0-9]{3,4}\\-?[0-9]{4,6}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        let emailRegEx1 = "^(1\\-)?[+][0-9]{2,3}\\-?[0-9]{2,3}\\-?[0-9]{3,4}\\-?[0-9]{4,6}$"
        let emailTest1 = NSPredicate(format: "SELF MATCHES %@", emailRegEx1)

        return emailTest.evaluate(with: self) || emailTest1.evaluate(with: self)
    }

    func isValidPhone2() -> Bool {
        let phoneRegEx = "^[+]?[0-9]{9,13}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }

    func isValidLatterAndNumber() -> Bool {
        let tatterAndNumberRegEx = "^[a-zA-Z0-9]+([_ .]?[a-zA-Z0-9])*$"
        //"^[a-zA-Z0-9]*$"
        let ltatterAndNumberTest = NSPredicate(format: "SELF MATCHES %@", tatterAndNumberRegEx)

        return ltatterAndNumberTest.evaluate(with: self)
    }

    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    func attributedString(fontSize: Float) -> NSAttributedString? {
        if(self == "") {
            return nil
        }
        let oldString = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)\">%@</span>", self)

        guard let data = oldString.data(using: String.Encoding.utf8,
                                        allowLossyConversion: false) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html

            ]
        let htmlString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

        // Removing this line makes the bug reappear
        htmlString?.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: 1))

        return htmlString
    }

    func attributedString() -> NSAttributedString? {
        if(self == "") {
            return nil
        }
        guard let data = self.data(using: String.Encoding.utf8,
                                   allowLossyConversion: false) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue,
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
        ]
        let htmlString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

        // Removing this line makes the bug reappear
        htmlString?.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: 1))

        return htmlString
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    func toAttributedString(color: UIColor, font: UIFont? = nil, isUnderLine: Bool = false) -> NSAttributedString {
        if let font = font {
            if isUnderLine {
                return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.underlineColor: color, NSAttributedString.Key.underlineStyle: 1])
            }
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        } else {
            return NSAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
        }

    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    subscript (bounds: Int) -> String {
        let start = index(startIndex, offsetBy: bounds)
        return String(self[start])
    }
}

extension String {
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func getSub(count: Int) -> String {
        if self.count > count {
            let start = String.Index(encodedOffset: 0)
            let end = String.Index(encodedOffset: count)
            let substring = String(self[start..<end])

            return "\(substring)..."
        }
        return self

    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }

        return String(data: data as Data, encoding: String.Encoding.utf8)
    }

    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }

        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }

    func removeTextInBase64() -> String {
        var str = self
        str = str.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
        str = str.replacingOccurrences(of: "data:image/png;base64,", with: "")
        str = str.replacingOccurrences(of: "data:image/jpg;base64,", with: "")

        return str
    }

    func toUIImage() -> UIImage? {
        let dataString = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        guard let data = dataString else { return nil }
        return UIImage(data: data)
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func getHeightLabel(width: CGFloat, font: UIFont) -> CGFloat{
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.text = self
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return floor(ceil(lbl.frame.height) / lbl.font.lineHeight)
    }

    func formatNumber(type: String) -> String {
        if self.count < 4 {
            return self
        }
        let firstValue = self.count - Int(self.count / 3) * 3
        var tempValue = ""
        var index = 0
        self.map({ (character) in
            if (index - firstValue) % 3 == 0 && index != 0 {
                tempValue += "\(type)\(character)"
            } else {
                tempValue += "\(character)"
            }
            index += 1
        })
        return tempValue
    }

    func getNumberListFromString() -> [Int] {
        var numList = [Int]()
        let stringArray = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Int(item) {
                numList.append(number)
            }
        }
        return numList
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func HTMLImageCorrector() -> String {
        let htmlString: String =  "<html><meta name='viewport' content='width=device-width, initial-scale=1'><head><link href='https://fonts.googleapis.com/css?family=Sofia' rel='stylesheet'><style>body { background: white; font-family: 'Open Sans' !important; font-size: 15px; } </style> </head> <body> <img align=\"middle\">" + self + "</body></html>"
        return htmlString
    }
    
    var showLanguage: String {
        let lang = LanguageHelper.currentAppleLanguage()
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension String {
    func convertDate(fromDateFormat: String = AppDateFormat.yyyyMMddHHmm.formatString, toDateFormat: String = AppDateFormat.HHmmddMMyyyy.formatString) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat

        if let date = dateFormatter.date(from: self) {
            return date.toString(formatString: toDateFormat)
        } else {
            return nil
        }
    }
}

extension String{
    static var dateFormatter : DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}


extension String {
    func formatNumber(style: String = " ",number: Int = 3) -> String {
        if self.count <= number {
            return self
        }
        var index = 1
        let firstCount = self.count % number
        let result = self.reduce("") { (result, char) -> String in
            if (index - firstCount) % number == 0 {
                index += 1
                return result + String(char) + style
            }
            index += 1
            return result + String(char)
        }
        return result
    }
}

extension String {
    func isWord() -> Bool {
        let regular = "[a-zA-Z]"
        let wordRegular = NSPredicate(format: "SELF MATCHES %@", regular)
        return wordRegular.evaluate(with: String(self))
    }
    //standardized string
    func standString() -> String{
        let count = self.count
        var result = ""
        for index in 0..<count {
            if index > 0 && self[index] == "\n" {
                 break
            }
            if !self[index].isWord() {
                result += ""
            } else {
                result += self[index]
            }
        }
        return result
    }
}

extension String {
    func convertFormatString() -> String {
        let strLowerCase = self.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
        var result = ""
        var indexDot = 0
        for (index,character) in strLowerCase.enumerated() {
            if index == 0 {
                result += String(character).uppercased()
            } else {
                if indexDot != 0 {
                    result += String(character).uppercased()
                } else {
                    result += String(character)
                }
                if character == "." {
                    indexDot = index
                } else {
                    if character != " " {
                        indexDot = 0
                    }
                }
            }
        }
        return result
    }
}

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}
