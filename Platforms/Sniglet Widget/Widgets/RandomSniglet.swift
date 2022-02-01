//
//  RandomSniglet.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import WidgetKit

struct RandomSniglet: Widget {
    let kind: String = "RandomSniglet_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RandomSnigletProvider()) { entry in
            RandomSnigletEV(entry: entry)
        }
        .configurationDisplayName("Random Sniglet")
        .description("View a random sniglet.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
