//
//  KActivityIndicatorAnimationDelegate.swift
//  DemoLoading
//
//  Created by Kai Pham on 8/16/18.
//  Copyright © 2018 Kai Pham. All rights reserved.
//


import UIKit

protocol KActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}

