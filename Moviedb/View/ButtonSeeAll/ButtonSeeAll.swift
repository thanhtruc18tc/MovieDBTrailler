//
//  ButtonSeeAll.swift
//  Moviedb
//
//  Created by Truc Tran on 5/25/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import UIKit

class ButtonSeeAll: UIView {
    @IBOutlet weak var lbButton : UILabel!
    @IBOutlet weak var imgButton : UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let nibName     = String(describing: type(of: self))
        let nib         = UINib(nibName: nibName, bundle: nil)
        guard let view        = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame      = bounds
        addSubview(view)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
