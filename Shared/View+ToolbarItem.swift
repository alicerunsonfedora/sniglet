//
//  View+ToolbarItem.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/13/22.
//

import SwiftUI
import Foundation

extension View {
    func customizeToolbarItem<Content: View>(
        with id: String,
        primary: Bool = false,
        hideByDefault: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> ToolbarItem<String, Content> {
        if #available(iOS 16.0, *) {
            return ToolbarItem(
                id: id,
                placement: primary ? .primaryAction: .secondaryAction,
                showsByDefault: !hideByDefault
            ) {
                content()
            }
        } else {
            return ToolbarItem(id: id, showsByDefault: !hideByDefault) {
                content()
            }
        }
    }
}
