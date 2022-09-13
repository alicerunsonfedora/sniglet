//
//  CustomizableToolbarView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 9/13/22.
//

import Foundation
import SwiftUI

struct CustomizableToolbarView<Content: View, TContent: CustomizableToolbarContent>: View {
    var id: String
    var content: () -> Content
    var toolbar: () -> TContent

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                content()
                    .toolbar(id: id) { toolbar() }
                    .toolbarRole(.editor)
            } else {
                content()
                    .toolbar(id: id) { toolbar() }
            }
        }
    }
}
