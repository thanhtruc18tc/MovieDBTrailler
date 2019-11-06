//
//  BaseTableCell.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    let vLine: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.lineNavigationBar
        
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    func setUpViews() {
        self.selectionStyle = .none
    }
    
    func addLineWhiteToBottom() {
        addSubview(vLine)
        vLine.anchor( left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}
