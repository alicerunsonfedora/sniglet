//
//  StringExtension.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import Foundation
import AppKit

extension String {

    /// Returns the localized strings from the Mac localization files.
    ///
    /// - Note: If the localization key exists in the shared localization file, use the standard localization features
    ///   instead.
    func fromMacLocale() -> String {
        Bundle.main.localizedString(forKey: self, value: nil, table: "Mac_Localizable")
    }

    /// Copies the string into the user's clipboard.
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(self, forType: .string)
    }
}
