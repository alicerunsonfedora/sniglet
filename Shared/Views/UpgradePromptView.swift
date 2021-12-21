//
//  UpgradePromptView.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/12/21.
//

import SwiftUI

/// A view that shows a prompt to upgrade to the Give Me a Sniglet+ IAP.
struct UpgradePromptView: View {

    /// An enumeration for the response types for this prompt.
    enum UpgradeResponse {

        /// The user is requesting the upgrade.
        case requestingUpgrade

        /// The user is cancelling the prompt.
        case cancelled
    }

    /// An action to run when the prompt closes, based on what the user has pressed.
    var onDismiss: (UpgradeResponse) -> Void

    /// The main view.
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("upgrade.title")
                .bold()
                .font(.title)
                .multilineTextAlignment(.center)
            Text("upgrade.subtitle")

            VStack(alignment: .leading, spacing: 24) {
                WhatsNewLabel(
                    title: LocalizedStringKey("upgrade.dictionary.title"),
                    subtitle: "upgrade.dictionary.detail",
                    systemImage: "bookmark"
                )
                WhatsNewLabel(
                    title: LocalizedStringKey("upgrade.icloud.title"),
                    subtitle: "upgrade.icloud.detail",
                    systemImage: "icloud"
                )
                WhatsNewLabel(
                    title: LocalizedStringKey("upgrade.models.title"),
                    subtitle: "upgrade.models.detail",
                    systemImage: "brain"
                )
            }
            Spacer()
            VStack {
                Button {
                    onDismiss(.requestingUpgrade)
                } label: {
                    Text("upgrade.accept")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: 400)
                }
                .buttonStyle(.borderedProminent)
                Button {
                    onDismiss(.cancelled)
                } label: {
                    Text("upgrade.cancel")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: 400)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
            }
            .padding(.bottom, 16)
        }
        .padding(16)
    }
}

struct UpgradePromptView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradePromptView() { _ in }
            .previewDevice("iPhone 13")
    }
}
