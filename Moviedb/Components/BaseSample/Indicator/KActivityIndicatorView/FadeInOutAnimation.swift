//
//  FadeInOutAnimation.swift
//  DemoLoading
//
//  Created by Kai Pham on 8/16/18.
//  Copyright © 2018 Kai Pham. All rights reserved.
//

import UIKit

/// Function that performs fade in/out animation.
public typealias FadeInAnimation = (UIView) -> Void

/// Function that performs fade out animation.
///
/// - Note: Must call the second parameter on the animation completion.
public typealias FadeOutAnimation = (UIView, @escaping () -> Void) -> Void
