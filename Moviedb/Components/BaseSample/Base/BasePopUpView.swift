//
//  BasePopUpView.swift
//  Ipos
//
//  Created by Kai Pham on 4/19/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit

typealias CompletionClosure = (() -> Void)
typealias CompletionMessage = ((_ message: String?) -> Void)
typealias CompletionAny = ((_ item: Any?) -> Void)
typealias CompletionDate = ((_ item: Date?) -> Void)
typealias CompletionUIImage = ((_ image: UIImage?) -> Void)

enum BasePopUpViewType {
    case fromLeftToCenter
    case fromRightToCenter
    case fromBottomToCenter
    case fromTopToCenter
    case zoomOut
    case showFromBottom
}

class BasePopUpView: UIView {
    let vBackGround: UIView = {
        let view                = UIView()
        view.backgroundColor    = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    
    let vContent: UIView = {
        let view                = UIView()
        view.backgroundColor    = UIColor.white
        view.setBorder(cornerRadius: 8)
        return view
    }()
    
    lazy var btnOver: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(self.btnOverTapped), for: .touchUpInside)
        
        return button
    }()
    
    var completionNo: CompletionClosure?
    var completionYes: CompletionClosure?
    var completionMessage: CompletionMessage?
    
    private var widthContent: CGFloat = 0
    private var heightContent: CGFloat = 0
    private var minXContent: CGFloat = 0
    private var minYContent: CGFloat = 0
    private var widthWindow: CGFloat = 0
    private var heightWindow: CGFloat = 0
    private var type: BasePopUpViewType = .fromLeftToCenter
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        addSubview(vBackGround)
        vBackGround.fillSuperview()
        vBackGround.addSubview(btnOver)
        btnOver.fillSuperview()
        vBackGround.addSubview(vContent)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        self.minYContent = (heightWindow - heightContent) / 2
        UIView.animate(withDuration: 0.5) {
            self.vContent.frame = CGRect(x: self.minXContent, y: self.minYContent, width: self.widthContent, height: self.heightContent)
        }
    }
    
    @objc func keyboardShow(notification : Notification){
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        self.minYContent = heightWindow - keyboardHeight - heightContent
        UIView.animate(withDuration: 0.5) {
            self.vContent.frame = CGRect(x: self.minXContent, y: self.minYContent, width: self.widthContent, height: self.heightContent)
        }
    }
    
    @objc func btnCloseTapped() {
        hidePopUp()
    }
    @objc func btnOverTapped() {
        hidePopUp()
    }
    
    func showPopUpNotRemoveView(width: CGFloat = 350 , height: CGFloat = 250, type: BasePopUpViewType = BasePopUpViewType.zoomOut) {
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 11.0, *) {
                widthWindow = window.safeAreaLayoutGuide.layoutFrame.width
                heightWindow = window.safeAreaLayoutGuide.layoutFrame.height
            } else {
                widthWindow = window.frame.width
                heightWindow = window.frame.height
            }
            
            //---
            widthContent = window.frame.width
            heightContent = height
            
            //--
            if type != .showFromBottom {
                widthContent = width
                minXContent = (widthWindow - width) / 2
                minYContent = (heightWindow - height) / 2
            } else {
                widthContent = widthWindow
                heightContent = height
                minXContent = 0
                minYContent = (heightWindow - height)
            }
            
            self.type = type
            
            //---
//            for sub in window.subviews {
//                if sub is BasePopUpView {
//                    sub.removeFromSuperview()
//                }
//            }
            window.addSubview(self)
            self.fillSuperview()
            self.vBackGround.alpha = 0
            
            //---
            showPopWithAnimation(type: type)
        }
    }
    
    func updateNewHeight(height: CGFloat){
        self.heightContent = height
        self.vContent.frame = CGRect(x: minXContent, y: minYContent, width: widthContent, height: heightContent)
    }
    
    func showPopUp(width: CGFloat = 350 , height: CGFloat = 250, type: BasePopUpViewType = BasePopUpViewType.zoomOut) {
        
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 11.0, *) {
                widthWindow = window.safeAreaLayoutGuide.layoutFrame.width
                heightWindow = window.safeAreaLayoutGuide.layoutFrame.height
            } else {
                widthWindow = window.frame.width
                heightWindow = window.frame.height
            }
            
            //---
            widthContent = window.frame.width
            heightContent = height
            
            //--
            if type != .showFromBottom {
                widthContent = width
                minXContent = (widthWindow - width) / 2
                minYContent = (heightWindow - height) / 2
            } else {
                widthContent = widthWindow
                heightContent = height
                minXContent = 0
                minYContent = (heightWindow - height)
            }
            
            self.type = type
            
            //---
            for sub in window.subviews {
                if sub is BasePopUpView {
                    sub.removeFromSuperview()
                }
            }
            window.addSubview(self)
            self.fillSuperview()
            self.vBackGround.alpha = 0
            
            //---
            showPopWithAnimation(type: type)
        }
    }
    
    
    
    func hidePopUp(success: ((Bool) -> Void)? = nil) {
        
        self.hidePopUpWithAnimation()
        
        //-- FIX ME
        if type == .zoomOut {
            
            //            AnimationHelper.shared.animationScaleOpacity(view: self.vContent, fromScale: 1, toScale: 0, fromOpacity: 1, toOpacity: 0, duration: 0.1) {
            //
            //            }
            
            self.vContent.frame = CGRect.zero
            self.vContent.alpha = 0
            self.removeFromSuperview()
            success?(true)
        } else {
            self.vBackGround.alpha = 1
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.hidePopUpWithAnimation()
                }, completion: { [weak self] _ in
                    guard let strongSelf = self else {
                        success?(false)
                        return }
                    
                    strongSelf.vBackGround.alpha = 0
                    strongSelf.removeFromSuperview()
                    success?(true)
            })
            
        }
        
    }
    
    private func hidePopUpWithAnimation() {
        switch type {
        case .fromBottomToCenter:
            self.vContent.frame = CGRect(x: minXContent, y: 0 - heightContent, width: widthContent, height: heightContent)
        case .fromLeftToCenter:
            self.vContent.frame = CGRect(x: widthWindow + widthContent, y: minYContent, width: widthContent, height: heightContent)
        case .fromRightToCenter:
            self.vContent.frame = CGRect(x: -widthContent, y: minYContent, width: widthContent, height: heightContent)
        case .fromTopToCenter:
            self.vContent.frame = CGRect(x: minXContent, y: heightWindow + heightContent, width: widthContent, height: heightContent)
        case .zoomOut:
            print("zoom")
        case .showFromBottom:
            self.vContent.frame = CGRect(x: minXContent, y: 0 - heightContent, width: widthContent, height: heightContent)
        }
    }
    
    private func showPopUpBeforeAnimation(type: BasePopUpViewType) {
        self.vBackGround.alpha = 0
        switch type {
        case .fromBottomToCenter:
            self.vContent.frame = CGRect(x: minXContent, y: 1000, width: widthContent, height: heightContent)
        case .fromLeftToCenter:
            self.vContent.frame = CGRect(x: -1000, y: minYContent, width: widthContent, height: heightContent)
        case .fromRightToCenter:
            self.vContent.frame = CGRect(x: 1000, y: minYContent, width: widthContent, height: heightContent)
        case .fromTopToCenter:
            self.vContent.frame = CGRect(x: minXContent, y: -1000, width: widthContent, height: heightContent)
        case .zoomOut:
            self.vBackGround.alpha = 1
            self.vContent.frame = CGRect(x: minXContent, y: minYContent, width: widthContent, height: heightContent)
        case .showFromBottom:
            self.vContent.frame = CGRect(x: minXContent, y: 1000, width: widthContent, height: heightContent)
        }
    }
    
    private func showPopWithAnimation(type: BasePopUpViewType) {
        showPopUpBeforeAnimation(type: type)
        
        switch type {
        case .fromBottomToCenter, .fromLeftToCenter, .fromRightToCenter, .fromTopToCenter:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: { [unowned self] in
                self.vBackGround.alpha = 1
                self.vContent.frame = CGRect(x: self.minXContent, y: self.minYContent, width: self.widthContent, height: self.heightContent)
                }, completion: nil)
            
        case .zoomOut:
            AnimationHelper.shared.animationScale(view: self.vContent, fromScale: 0.1, toScale: 1)
            
        case .showFromBottom:
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.vBackGround.alpha = 1
                self.vContent.frame = CGRect(x: self.minXContent, y: self.minYContent, width: self.widthContent, height: self.heightContent)
            }
            
        }
    }
    
}
