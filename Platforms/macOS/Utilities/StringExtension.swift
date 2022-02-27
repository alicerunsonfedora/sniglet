//
//  StringExtension.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import Foundation

extension String {

    /// Returns the localized strings from the Mac localization files.
    ///
    /// - Note: If the localization key exists in the shared localization file, use the standard localization features
    ///   instead.
    func fromMacLocale() -> String {
        Bundle.main.localizedString(forKey: self, value: nil, table: "Mac_Localizable")
    }
}
