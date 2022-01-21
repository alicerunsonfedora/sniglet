//
//  SettingsSafariWindow.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/1/22.
//

import Foundation
import SwiftUI

/// A view that shows an AppLink in a ``SafariView``.
struct SettingsSafariWindow: View {

    /// The app link to display in the browser.
    ///
    /// This is set to a binding because, when used in a sheet, the link is set on time of sheet creation.
    @Binding var link: AppLink

    var body: some View {
        Group {
            switch link {
            case .feedback:
                SafariView(AppLink.feedback.rawValue)
            case .license:
                SafariView(AppLink.license.rawValue)
                    .prefersReaderMode()
            default:
                VStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No Link Provided")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Debug: AppLink type is " + String(describing: link))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                    .padding()
            }
        }
    }

}
