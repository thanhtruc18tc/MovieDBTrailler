//
//  Button+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit

extension UIButton {
    func linearGradientBackground() {
        self.linearGradientBackground(colors: [UIColor(red: 0.94, green: 0.4, blue: 0.18, alpha: 1).cgColor, UIColor(red: 0.96, green: 0.56, blue: 0.29, alpha: 1).cgColor, UIColor(red: 0.99, green: 0.8, blue: 0.1, alpha: 1).cgColor], cornerRadius: 29.0, locations: [0, 0.57, 1])
        
        //Set CAGradientLayer under UIButton with image
        if let btnImage = self.imageView {
            self.bringSubviewToFront(btnImage)
        }
    }
    
    func setAttributed(title: String, color: UIColor, font: UIFont?, isUnderLine: Bool = false ) {
        var attr = NSAttributedString()
        if isUnderLine {
            attr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        } else {
            attr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font!])
        }
        self.setAttributedTitle(attr, for: .normal)
    }

    func setAnimationTouch() {
        UIButton.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIButton.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }

}
