//
//  SharedActivity.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/1/22.
//

import Foundation
import SwiftUI

/// A view that display a `UIActivityViewController` to share an item.
struct SharedActivity: UIViewControllerRepresentable {

    /// The list of activities to share or take action on.
    let activities: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIActivityViewController {
        UIActivityViewController(activityItems: activities, applicationActivities: nil)
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<Self>
    ) { return }

}
