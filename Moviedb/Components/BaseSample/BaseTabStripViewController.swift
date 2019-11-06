//
//  BaseTabStripViewController.swift
//  EnglishApp
//
//  Created by Kai Pham on 5/10/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BaseTabStripViewController: ButtonBarPagerTabStripViewController {
    var listViewController = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpNavigation() {
        self.view.backgroundColor = UIColor.white
        guard let navigationController = self.navigationController else { return }
        //---
        navigationController.navigationBar.barTintColor = UIColor.white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension ButtonBarPagerTabStripViewController {
    func setUpViews() {}
    
    func transparentNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
    }
    
    func showNavigation() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func hideBackButton(){
        self.navigationItem.setHidesBackButton(true, animated:true);
    }
    
    func hideNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTitleView(titleView: UIView) {
        titleView.frame = CGRect(x: 0, y: 0, width: 1000, height: 49)
        self.navigationItem.titleView = titleView
        self.navigationItem.hidesBackButton = true
    }
    
}
extension ButtonBarPagerTabStripViewController {
    func setTitleImageNavigation(image: UIImage) {
        showNavigation()
        let view = UIView()
        let imageView = UIImageView(image:image)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 9, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        self.navigationItem.titleView = view
    }
    
    func addTwoButtonToNavigation(image1: UIImage, action1: Selector?, image2: UIImage, action2: Selector?) {
        showNavigation()
        let btn1 = UIButton()
        btn1.setImage(image1, for: .normal)
        if let newAction = action1 {
            btn1.addTarget(self, action: newAction, for: .touchUpInside)
        }
        
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        btn1.contentHorizontalAlignment = .right
        let button1 = UIBarButtonItem(customView: btn1)
        
        //---
        let btn2 = UIButton()
        btn2.setImage(image2, for: .normal)
        if let newAction = action2 {
            btn2.addTarget(self, action: newAction, for: .touchUpInside)
        }
        btn2.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn2.contentHorizontalAlignment = .right
        
        let button2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.rightBarButtonItems = [button1, button2]
    }
    
    func addButtonTextToNavigation(title: String, style: StyleNavigation, action: Selector?, textColor: UIColor = AppColor.rightNavigation) {
        
        showNavigation()
        let btn = UIButton()
        
        var newTitle = title
        if style == .right {
            newTitle = title
        }
        
        btn.setAttributed(title: newTitle, color: textColor, font: UIFont.systemFont(ofSize: 17))
        
        btn.setTitleColor(textColor, for: .normal)
        if let newAction = action {
            btn.addTarget(self, action: newAction, for: .touchUpInside)
        }
        btn.sizeToFit()
        
        let button = UIBarButtonItem(customView: btn)
        if style == .left {
            self.navigationItem.leftBarButtonItem = button
        } else {
            self.navigationItem.rightBarButtonItem = button
        }
    }
    
    func setTitleWhiteNavigation(title: String, textColor: UIColor = UIColor.white, action: Selector? = nil ) {
        let lb = UILabel()
        lb.text             = title
        lb.textAlignment    = .center
        lb.numberOfLines    = 2
        lb.textColor        = textColor
        lb.sizeToFit()
        
        let vTest = UIView()
        vTest.isUserInteractionEnabled = true
        vTest.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
        vTest.addSubview(lb)
        lb.centerSuperview()
        lb.font = AppFont.fontRegular18
        let tap = UITapGestureRecognizer(target: self, action: action)
        lb.isUserInteractionEnabled = true
        lb.addGestureRecognizer(tap)
        self.navigationItem.titleView = vTest
    }
}
