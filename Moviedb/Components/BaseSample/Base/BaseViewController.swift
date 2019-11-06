//
//  BaseViewController.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//
import UIKit
import Alamofire

enum StyleNavigation {
    case left
    case right
}

open class BaseViewController: UIViewController {
    
    let mainBackgroundColor = UIColor.white
    let mainNavigationBarColor = UIColor.white
    
    lazy var btnLike : UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        return btn
    }()
    
    lazy var btnRight : UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        return btn
    }()
    
    var statusBarHidden = false
    
    open override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //store.subscribe(self)
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setUpViews()
        setUpNavigation()
        print(self.nibName)
    }
    
    let lbNodata: UILabel = {
        let btn = UILabel()
        btn.textAlignment = .center
        btn.font = AppFont.fontRegular14
        
        return btn
    }()
    
    func setUpViews() {}
    func setTitleUI() {}
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitleUI()
        checkInternet()
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setColorStatusBar(color: UIColor = AppColor.yellow) {
        guard #available(iOS 13, *) else {
            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
               statusBar.backgroundColor = color
               statusBar.tintColor =  color
            }
            return
        }
    }
    
    func setUpNavigation() {
        guard let navigationController = self.navigationController else { return }
        //---
        navigationController.navigationBar.barTintColor = mainNavigationBarColor
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)
        
        setNavigationColor()
    }
    
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
    
    func showBlackNavigation() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func hideNavigation() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTitleView(titleView: UIView) {
        titleView.frame = CGRect(x: 0, y: 0, width: 1000, height: 49)
        self.navigationItem.titleView = titleView
        self.navigationItem.hidesBackButton = true
    }
    
    func setNavigationColor(color: UIColor = AppColor.yellow) {
        self.navigationController?.navigationBar.barTintColor = color
    }
    
    func pushUpFromBottomView(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(controller, animated: false)
    }
    func closeView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
    
    //---
    func showNoData(text: String = LocalizableKey.lbNoData.showLanguage) {
        lbNodata.removeFromSuperview()
        self.view.addSubview(lbNodata)
        lbNodata.text = text
        lbNodata.centerSuperview()
    }
    
    func hideNoData() {
        lbNodata.removeFromSuperview()
    }
    
    func checkInternet() {
        if !Utils.isConnectedToInternet() {
            PopUpHelper.shared.showNoInternet {
            }
        }
    }
    
}

// MARK: Add button left, right, title
extension BaseViewController {
    func addButtonLikeToNavigation(image: UIImage, actionSelector: Selector?){
        btnLike.setBackgroundImage(image, for: .normal)
        if let newAction = actionSelector {
            btnLike.addTarget(self, action: newAction, for: .touchUpInside)
        }
        btnLike.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnLike.contentHorizontalAlignment = .right
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnLike)
    }
    
    func addButtonToNavigation(image: UIImage, style: StyleNavigation, action: Selector?) {
        showNavigation()
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        if let newAction = action {
            btn.addTarget(self, action: newAction, for: .touchUpInside)
        }
        
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        
        let button = UIBarButtonItem(customView: btn)
        if style == .left {
            btn.contentHorizontalAlignment = .left
            self.navigationItem.leftBarButtonItem = button
        } else {
            self.navigationItem.rightBarButtonItem = button
            btn.contentHorizontalAlignment = .right
        }
    }
    
    func addButtonNotificationNavigation(count: Int, action: Selector?) {
        showNavigation()
        let btn = UIButton()
        btn.setImage(AppImage.imgNotification, for: .normal)
        if let newAction = action {
            btn.addTarget(self, action: newAction, for: .touchUpInside)
        }
        
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        
        if count > 0 {
            let lbCount = UILabel()
            lbCount.backgroundColor = .red
            lbCount.font = AppFont.fontRegular8
            btn.addSubview(lbCount)
            
            lbCount.textAlignment = .center
            lbCount.textColor = .white
            lbCount.text = count.description
            
            lbCount.anchor(btn.topAnchor, right: btn.rightAnchor, topConstant: -4, rightConstant: -4, widthConstant: 16, heightConstant: 16)
            lbCount.setBorder(cornerRadius: 8)
            
            if count > 9 {
                lbCount.text = "9+"
            }
        }
        
        
        let button = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = button
        btn.contentHorizontalAlignment = .right
    }
    
    func addButtonToNavigation(title: String, style: StyleNavigation, action: Selector?, backgroundColor: UIColor = UIColor.white, textColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 17), cornerRadius: CGFloat = 0, size: CGSize = CGSize(width: 30, height: 20)) -> UIButton{
        
        showNavigation()
        if let newAction = action {
            btnRight.addTarget(self, action: newAction, for: .touchUpInside)
        }
        btnRight.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnRight.layer.cornerRadius = cornerRadius
        btnRight.backgroundColor = backgroundColor
        btnRight.contentHorizontalAlignment = .center
        //        btnRight.setAttributed(title: title, color: textColor, font: font)
        btnRight.titleLabel?.font = font
        btnRight.setTitleColor(textColor, for: .normal)
        btnRight.setTitle(title, for: .normal)
        
        let button = UIBarButtonItem(customView: btnRight)
        if style == .left {
            self.navigationItem.leftBarButtonItem = button
        } else {
            self.navigationItem.rightBarButtonItem = button
        }
        return btnRight
    }
    
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
    
    func addTwoViewToNavigation(view1: UIView?,image1: UIImage?, action1: Selector?, view2: UIView?,image2: UIImage?, action2: Selector?) -> (){
        showNavigation()
        let button1 : UIBarButtonItem!
        if image1 != nil {
            let btn1 = UIButton()
            btn1.setImage(image1, for: .normal)
            if let newAction = action1 {
                btn1.addTarget(self, action: newAction, for: .touchUpInside)
            }
            
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.contentHorizontalAlignment = .right
            button1 = UIBarButtonItem(customView: btn1)
        } else {
            button1 = UIBarButtonItem(customView: view1 ?? UIView())
            button1.width = 34
        }
        
        let button2 : UIBarButtonItem!
        
        if image2 != nil {
            btnLike.setBackgroundImage(image2, for: .normal)
            if let newAction = action2 {
                btnLike.addTarget(self, action: newAction, for: .touchUpInside)
            }
            btnLike.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btnLike.contentHorizontalAlignment = .right
            button2 = UIBarButtonItem(customView: btnLike)
        } else {
            button2 = UIBarButtonItem(customView: view2 ?? UIView())
        }
        
        //---
        self.navigationItem.rightBarButtonItems = [button2, button1]
    }
    
    func addButtonTextToNavigation(title: String, style: StyleNavigation, action: Selector?, textColor: UIColor = AppColor.rightNavigation, font : UIFont = UIFont.systemFont(ofSize: 17)) {
        
        showNavigation()
        let btn = UIButton()
        
        var newTitle = title
        if style == .right {
            newTitle = title
        }
        
        btn.setAttributed(title: newTitle, color: textColor, font: font)
        
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
    
    func setTitleNavigation(title: String, textColor: UIColor = UIColor.white, action: Selector? = nil ) {
        
        showNavigation()
        let vTitle = TitleNavigationBar()
        vTitle.lbTitle.text = title
        vTitle.frame = CGRect(x: 0, y: 0, width: 375, height: 44)
        self.navigationItem.titleView = vTitle
        
    }
    
    func addButtonImageToNavigation(image: UIImage, style: StyleNavigation, action: Selector?) {
        showNavigation()
        let btn = UIButton()
        btn.setImage(image, for: .normal)
        if let newAction = action {
            btn.addTarget(self, action: newAction, for: .touchUpInside)
        }
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        
        btn.imageView?.contentMode = .scaleAspectFit
        let button = UIBarButtonItem(customView: btn)
        if style == .left {
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 20)
            btn.contentHorizontalAlignment = .left
            self.navigationItem.leftBarButtonItem = button
        } else {
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 0)
            self.navigationItem.rightBarButtonItem = button
            btn.contentHorizontalAlignment = .right
        }
    }
}

extension BaseViewController {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
    }
}
extension BaseViewController {
    func addBackToNavigation(icon: UIImage = UIImage(named: "Material_Icons_white_chevron_left")! ) {
        addButtonImageToNavigation(image: icon, style: .left, action: #selector(btnBackTapped))
    }
    
    @objc func btnBackTapped() {
        view.endEditing(true)
        self.pop(animated: true)
    }
    
    func addCloseToNavigation(icon: UIImage = AppImage.imgClose ) {
        addButtonImageToNavigation(image: icon, style: .left, action: #selector(btnCloseTapped))
    }
    
    @objc func btnCloseTapped() {
        self.dismiss()
    }
}

extension BaseViewController {
    func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    func setBlackNavigation() {
        self.navigationController?.navigationBar.barTintColor = .black
    }
    
    func setWhiteCloseNavigation() {
        addButtonImageToNavigation(image: #imageLiteral(resourceName: "cancel_white"), style: .left, action: #selector(btnCloseTapped))
    }
    
    func addHeaderUser() {
        let header = HeaderUserView()
        
        //        header.frame = CGRect(x: 0, y: 0, width: 414, height: 375)
        //         self.navigationItem.titleView = header
        self.navigationController?.navigationBar.addSubview(header)
        header.fillSuperview()
    }
}

//check connection

extension BaseViewController {
    var isConnection : Bool {
        get{
            return NetworkReachabilityManager()?.isReachable ?? false
        }
    }
}

//
//class SwipeController: UINavigationController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//    }
//
//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        super.pushViewController(viewController, animated: animated)
////        self.interactivePopGestureRecognizer?.isEnabled = false
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
////        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
//}
//
//extension SwipeController : UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
