//
//  BaseView.swift
//  Ipos
//
//  Created by Kai Pham on 4/17/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }

    func setUpViews() {

    }
}
