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

    /// Whether to enter reader mode by default.
    let reader: Bool

    init(_ urlString: String, reader: Bool = false) {
        self.url = URL(string: urlString)!
        self.reader = reader
    }

    init(_ url: URL, reader: Bool = false) {
        self.url = url
        self.reader = reader
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.configuration.entersReaderIfAvailable = reader
        return controller
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
        return
    }
}

extension SafariView {
    func prefersReaderMode() -> some View {
        SafariView(self.url, reader: true)
    }
}
