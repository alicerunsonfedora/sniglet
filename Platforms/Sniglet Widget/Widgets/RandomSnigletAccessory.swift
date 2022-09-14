//
//  RandomSnigletAccessory.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/14/22.
//

import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct RandomSnigletAccessory: Widget {
    let kind: String = "RandomSniglet_AccessoryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RandomSnigletProvider()) { entry in
            RandomSnigletAccessoryEV(entry: entry)
        }
        .configurationDisplayName("Random Sniglet")
        .description("View a random sniglet.")
        .supportedFamilies([.accessoryRectangular])
    }
}
