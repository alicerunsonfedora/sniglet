//
//  UIView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/1/22.
//

import Foundation
import UIKit

extension UIView {

    /// Renders the view into an image.
    ///
    /// Original: https://codakuma.com/swiftui-view-to-image/
    var renderedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 2)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
}
