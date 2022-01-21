//
//  AppLinks.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/1/22.
//

import Foundation

/// An enumeration for the various app links.
public enum AppLink: String {

    /// A link that redirects to the YouTrack bug reporter.
    case feedback = "https://youtrack.marquiskurt.net/youtrack/newIssue?project=ABY"

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
