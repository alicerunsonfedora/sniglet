//
//  MainEntry+WhatsNewProvider.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/13/22.
//

import SwiftUI
import WhatsNewKit

extension SnigletApp: WhatsNewCollectionProvider {
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.2.0",
            title: .init(
                text: .init(.localized("feat.title")),
                foregroundColor: .accentColor),
            features: [
                .init(
                    image: .init(systemName: "rectangle.stack.fill"),
                    title: .init(.localized("feat.stack.title")),
                    subtitle: .init(.localized("feat.stack.detail"))
                ),
            ]
        )
    }
}

fileprivate extension String {
    static func localized(_ key: String) -> String {
        Self(localized: .init(key))
    }
}
