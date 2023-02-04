//
//  AppLinks.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/1/22.
//

import Foundation

/// An enumeration for the various app links.
public enum AppLink: String {
    /// A link that redirects to the Feedback Portal.
    case feedback = "https://feedback.marquiskurt.net/composer?primary_tag=sniglets"

    /// A link that redirects to the official Mozilla Public License webpage.
    case license = "https://www.mozilla.org/en-US/MPL/2.0/"

    /// A blank page.
    /// - Important: This will cause an error in an `SFSafariViewController`.
    case none = "about:blank"

    /// A link that opens the privacy policy for this app.
    case privacyPolicy = "https://marquiskurt.net/app-privacy.html"

    /// A link that redirects to the GitHub source code.
    case source = "https://github.com/alicerunsonfedora/sniglet"
}

extension URL {
    init?(appLink: AppLink) {
        self.init(string: appLink.rawValue)
    }
}
