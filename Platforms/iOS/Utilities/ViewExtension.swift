//
//  ViewExtension.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 3/7/22.
//

import Foundation
import SwiftUI

extension View {
    /// Generates an image used to share with others.
    /// - Parameter preview: The view that will host the saved image.
    /// - Returns: A UIImage containing the rendered view of the saved image.
    ///
    /// Original: https://codakuma.com/swiftui-view-to-image/
    func makeImage<Content: View>(in preview: Content) -> UIImage {
        let window = UIWindow(
            frame: CGRect(
                origin: .init(x: 0, y: -225),
                size: CGSize(width: 550, height: 275)
            )
        )

        let hosting = UIHostingController(rootView: preview)
        hosting.view.frame = window.frame
        hosting.view.backgroundColor = UIColor.savedBackground

        window.backgroundColor = .savedBackground
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()

        return hosting.view.renderedImage
    }
}
