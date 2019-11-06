//
//  UIViewController+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/17/19.
//  Copyright © 2019 edward. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    static func initFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>(_ : T.Type) -> T {
            print(String(describing: T.self))
            return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib(self)
    }

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            } else {
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
}

extension UIViewController {
    func push(controller: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }

    func pop(animated: Bool = true ) {
        self.navigationController?.popViewController(animated: animated)
    }

    func present(controller: UIViewController, animated: Bool = true) {
        self.present(controller, animated: animated, completion: nil)
    }

    func dismiss(animated: Bool = true) {
        self.dismiss(animated: animated, completion: nil)
    }
}

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
//        if #available(iOS 13.0, *) {
//            if let statusBar = self.view.window?.windowScene?.value(forKey: "statusBar") as? UIView {
//                statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
//            }
//        } else {
//            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//                statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
//            }
//        }
        
        guard #available(iOS 13.0, *) else {
            if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
            }
            return
        }
    }
}
