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
                    image: .init(systemName: "externaldrive.badge.icloud"),
                    title: .init(.localized("feat.dictionary.title")),
                    subtitle: .init(.localized("feat.dictionary.detail"))
                ),
                .init(
                    image: .init(systemName: "applewatch.watchface"),
                    title: .init(.localized("feat.watch.title")),
                    subtitle: .init(.localized("feat.watch.detail"))
                ),
                .init(
                    image: .init(systemName: "dot.circle.and.hand.point.up.left.fill"),
                    title: .init(.localized("feat.actions.title")),
                    subtitle: .init(.localized("feat.actions.detail"))
                ),
                .init(
                    image: .init(systemName: "square.and.arrow.up"),
                    title: .init(.localized("feat.share.title")),
                    subtitle: .init(.localized("feat.share.detail"))
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
