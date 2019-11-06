//
//  UIImage+extension.swift
//  Ipos
//
//  Created by Kai Pham on 4/18/19.
//  Copyright © 2019 edward. All rights reserved.
//

import UIKit
import ImageIO

let maxWidthImage: CGFloat = 750

extension UIImage {
    func tintPicto(_ fillColor: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage!, in: rect)
        }
    }

    /**
     Modified Image Context, apply modification on image
     
     - parameter draw: (CGContext, CGRect) -> ())
     
     - returns: UIImage
     */
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> Void) -> UIImage {

        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    //https://stackoverflow.com/questions/32553741/ios-replaced-back-button-too-close-to-edge/32576128

    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)

        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithInsets
    }

    func resizeImage(maxWidth: CGFloat) -> UIImage {
        if self.size.width > maxWidth {
            let scale = maxWidth / self.size.width
            let newHeight = scale * self.size.height

            UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: newHeight))
            self.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }
        return self
    }
}
