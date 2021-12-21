//
//  WhatsNewView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 17/12/21.
//

import SwiftUI

/// A view that shows a prompt displaying the new features.
struct WhatsNewView: View {

    /// An action that executes when the prompt is closed, after writing logic to not display it again.
    var onDismiss: () -> Void

    /// The primary body of the view.
    var body: some View {
        VStack(spacing: 48) {
            Spacer()

            Text("What's New in Give Me a Sniglet")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 32) {
                WhatsNewLabel(
                    title: LocalizedStringKey("feat.watch.title"),
                    subtitle: "feat.watch.detail",
                    systemImage: "applewatch.watchface"
                )
                WhatsNewLabel(
                    title: LocalizedStringKey("feat.dictionary.title"),
                    subtitle: "feat.dictionary.detail",
                    systemImage: "bookmark"
                )
                WhatsNewLabel(
                    title: LocalizedStringKey("feat.icloud.title"),
                    subtitle: "feat.icloud.detail",
                    systemImage: "icloud"
                )
            }

            Spacer()

            VStack {
                Button {
                    writeAppVersion()
                    onDismiss()
                } label: {
                    Text("feat.accept")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: 400)
                }
                .buttonStyle(.borderedProminent)
                Text("feat.prompt")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 16)
        }
        .padding(16)
    }

    /// Write the current version to the user defaults.
    /// This is used to determine whether or not the user has seen the dialog.
    private func writeAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            UserDefaults.standard.set(version, forKey: "app-version")
        }
    }
}

/// A view that represents a label for the "What's New" dialog.
struct WhatsNewLabel: View {
    /// The title or main point in the label.
    @State var title: LocalizedStringKey

    /// The subtitle or the supporting text in the label.
    @State var subtitle: LocalizedStringKey

    /// The icon that will be displayed on the left side of the label.
    @State var systemImage: String

    /// The primary body of the view.
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .bold()
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 32)
        }
    }

}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView() {

        }
        .previewDevice("iPhone 13")
    }
}
