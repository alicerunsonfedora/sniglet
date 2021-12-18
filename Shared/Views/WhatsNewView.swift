//
//  WhatsNewView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 17/12/21.
//

import SwiftUI

struct WhatsNewView: View {
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 48) {
            Spacer()

            Text("What's New in Give Me a Sniglet")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 32) {
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
                WhatsNewLabel(
                    title: LocalizedStringKey("feat.watch.title"),
                    subtitle: "feat.watch.detail",
                    systemImage: "applewatch.watchface"
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

    private func writeAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            UserDefaults.standard.set(version, forKey: "app-version")
        }
    }
}

struct WhatsNewLabel: View {
    @State var title: LocalizedStringKey
    @State var subtitle: LocalizedStringKey
    @State var systemImage: String


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
