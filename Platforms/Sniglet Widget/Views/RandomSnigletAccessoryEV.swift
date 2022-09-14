//
//  RandomSnigletAccessoryEV.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 9/14/22.
//

import SwiftUI
import WidgetKit

@available(iOS 16.0, *)
struct RandomSnigletAccessoryEV : View {
    var entry: RandomSnigletProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.result.word)
                .font(.system(.body, design: .serif))
                .bold()
            Text("Confidence: \(entry.result.confidence.asPercentage())%")
                .font(.caption)
        }
    }
}

struct Sniglet_Widget_Accessory_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOSApplicationExtension 16.0, *) {
                RandomSnigletAccessoryEV(entry: SnigletEntry(date: Date(), result: .empty()))
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            } else {
                // Fallback on earlier versions
            }
        }

    }
}

