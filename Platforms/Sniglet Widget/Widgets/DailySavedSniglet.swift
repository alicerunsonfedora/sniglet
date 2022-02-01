//
//  DailySavedSniglet.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import WidgetKit

struct DailySavedSniglet: Widget {
    let kind: String = "DailySavedSniglet_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: SavedWOTDProvider(
                managedObjectContext: DBController.shared.container.viewContext,
                previewMOC: DBController.preview.container.viewContext
            )
        ) { entry in
            SavedWOTDEV(entry: entry)
        }
        .configurationDisplayName("Daily Saved Sniglet")
        .description("View a random sniglet from your dictionary daily.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
