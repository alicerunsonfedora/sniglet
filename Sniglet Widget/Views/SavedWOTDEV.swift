//
//  SavedWOTDEV.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import WidgetKit

struct SavedWOTDEV: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: SavedWOTDProvider.Entry

    var hasDefinition: Bool {
        entry.word.note != nil && entry.word.note! != ""
    }

    var body: some View {
        ZStack {
            Color("WidgetBackground")

            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Saved Sniglet")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .bold()
                Spacer()
                wordStack
                if widgetFamily == .systemMedium && hasDefinition {
                    Text(entry.word.note ?? "")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(.white)
                }
                Spacer()
                wordConfidence
            }
            .padding()
        }
    }

    var wordStack: some View {
        HStack {
            if widgetFamily == .systemSmall {
                Spacer()
            }
            Text(entry.word.word ?? "")
                .font(.system(
                    widgetFamily == .systemMedium ? .title : .title2,
                    design: .serif)
                )
                .bold()
                .foregroundColor(.white)
            Spacer()
        }
    }

    var wordConfidence: some View {
        VStack(alignment: .leading) {
            WidgetConfidenceBar(condifence: entry.word.confidence)
                .frame(height: 6)
            Text("Confidence: \(entry.word.confidence.asPercentage())%")
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}

struct SavedWOTDEV_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SavedWOTDEV(entry: .init(date: Date(), word: DBController.preview.singleEntry()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            SavedWOTDEV(entry: .init(date: Date(), word: DBController.preview.singleEntry()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }

    }
}
