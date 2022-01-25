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
    fileprivate let reader: Bool

    /// Whether to collapse the bar.
    fileprivate let collapseBar: Bool

    /// - Parameter urlString: A string containing the URL the Safari view controller will open.
    init(_ urlString: String) {
        self.init(urlString, reader: false, collapses: false)
    }

    /// - Parameter url: The URL the Safari view controller will open.
    init(_ url: URL) {
        self.init(url, reader: false, collapses: false)
    }

    fileprivate init(_ urlString: String, reader: Bool = false, collapses collapseBar: Bool = false) {
        self.url = URL(string: urlString)!
        self.reader = reader
        self.collapseBar = collapseBar
    }

    fileprivate init(_ url: URL, reader: Bool = false, collapses collapseBar: Bool = false) {
        self.url = url
        self.reader = reader
        self.collapseBar = collapseBar
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = reader
        configuration.barCollapsingEnabled = collapseBar
        return SFSafariViewController(url: url, configuration: configuration)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
        return
    }
}

extension SafariView {

    /// Sets whether Reader Mode should open automatically when the page loads.
    func prefersReaderMode(_ prefersReaderMode: Binding<Bool>) -> SafariView {
        SafariView(self.url, reader: prefersReaderMode.wrappedValue, collapses: self.collapseBar)
    }

    /// Sets whether the browser bar automatically collapses when the user scrolls.
    func collapsible(_ collapsible: Binding<Bool>) -> SafariView {
        SafariView(self.url, reader: self.reader, collapses: collapsible.wrappedValue)
    }
}
