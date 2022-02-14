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
        VStack(spacing: 32) {
            Spacer()

            Text("feat.title")
                .bold()
                .font(.system(.title, design: .rounded))
                .multilineTextAlignment(.center)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    WhatsNewLabel(
                        title: LocalizedStringKey("feat.dictionary.title"),
                        subtitle: "feat.dictionary.detail",
                        systemImage: "externaldrive.badge.icloud"
                    )
                    // TODO: Show this part once models are fully ready.
//                    WhatsNewLabel(
//                        title: LocalizedStringKey("feat.models.title"),
//                        subtitle: "feat.models.detail",
//                        systemImage: "brain"
//                    )
                    #if !targetEnvironment(macCatalyst)
                    WhatsNewLabel(
                        title: LocalizedStringKey("feat.watch.title"),
                        subtitle: "feat.watch.detail",
                        systemImage: "applewatch.watchface"
                    )
                    WhatsNewLabel(
                        title: LocalizedStringKey("feat.actions.title"),
                        subtitle: "feat.actions.detail",
                        systemImage: "dot.circle.and.hand.point.up.left.fill"
                    )
                    #else
                    WhatsNewLabel(
                        title: LocalizedStringKey("feat.listen.title"),
                        subtitle: "feat.listen.detail",
                        systemImage: "speaker.wave.3"
                    )
                    WhatsNewLabel(
                        title: LocalizedStringKey("feat.share.title"),
                        subtitle: "feat.share.detail",
                        systemImage: "square.and.arrow.up"
                    )
                    #endif
                }
            }

            Spacer()

            VStack {
                Button {
                    writeAppVersion()
                    onDismiss()
                } label: {
                    Text("feat.accept")
                        .frame(maxWidth: 400)
                }
                .keyboardShortcut(.defaultAction)
                .headerProminence(.increased)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
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
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
            }
        } icon: {
            Image(systemName: systemImage)
                .font(.title3)
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
