//
//  BaseViewXib.swift
//  Ipos
//
//  Created by Kai Pham on 4/17/19.
//  Copyright © 2019 edward. All rights reserved.
//
import UIKit

class BaseViewXib: UIView {
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
        view.fillVerticalSuperview()
        view.fillHorizontalSuperview()
        setUpViews()
    }

    func setUpViews() {
        
    }
}
