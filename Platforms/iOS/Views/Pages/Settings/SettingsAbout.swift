//
//  SettingsAbout.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI

struct SettingsAboutView: View {

    /// Whether to display the Safari view used for opening the feedback/licensing pages.
    @State private var showSafariView: Bool = false

    /// The link to use.
    @State private var safariLink: AppLink = .none

    var body: some View {
        Group {
            Section {
                HStack {
                    Text("settings.info.version")
                    Spacer()
                    Text(getAppVersion())
                        .foregroundColor(.secondary)
                }
                Button {
                    showSafariWindow(to: .license)
                } label: {
                    HStack {
                        Text("License")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("MPLv2")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("settings.info.header")
            } footer: {
                Text("settings.info.footer")
            }

            // Actionable Items
            Section {
                Button {
                    showSafariWindow(to: .feedback)
                } label: {
                    Label("settings.info.feedback", systemImage: "exclamationmark.bubble")
                }
                Link(
                    destination: URL(string: AppLink.privacyPolicy.rawValue)!
                ) {
                    Label("settings.info.privacy", systemImage: "hand.raised")
                }
                Link(
                    destination: URL(string: AppLink.source.rawValue)!
                ) {
                    Label("settings.info.source", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }
        }
        .onAppear {
            showSafariView = false
        }
        .sheet(isPresented: $showSafariView) {
            VStack {
                SettingsSafariWindow(link: $safariLink)
            }
        }
    }

    /// Show the in-app Safari window and open the corresponding link.
    /// - Parameter link: The app link to open in the Safari in-app browser.
    private func showSafariWindow(to link: AppLink) {
        safariLink = link
        showSafariView.toggle()
    }
}
