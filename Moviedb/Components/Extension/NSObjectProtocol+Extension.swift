//
//  NSObjectProtocol+Extension.swift
//  Ipos
//
//  Created by edward on 4/12/19.
//  Copyright © 2019 edward. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
