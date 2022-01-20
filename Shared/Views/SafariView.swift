//
//  SafariView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/1/22.
//

import SwiftUI
import SafariServices

/// A view that displays an in-app browser using `SFSafariViwController`.
struct SafariView: UIViewControllerRepresentable {

    /// The URL to load into the Safari view controller.
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
        return
    }
}
