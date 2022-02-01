//
//  RandomSnigletEV.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI
import WidgetKit

struct RandomSnigletEV : View {
    var entry: RandomSnigletProvider.Entry

    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        ZStack {
            Color("WidgetBackground")

            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                HStack {
                    Spacer()
                    Text(entry.result.word)
                        .font(.system(widgetFamily == .systemMedium ? .title : .title2, design: .serif))
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                WidgetConfidenceBar(condifence: entry.result.confidence)
                    .frame(maxHeight: 4)
                HStack {
                    Text("Confidence: \(entry.result.confidence.asPercentage())%")
                        .foregroundColor(.white)
                        .font(.caption)

                    if widgetFamily == .systemMedium {
                        Spacer()
                        Text(entry.date, style: .time)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }

            }
            .padding()
            .frame(maxWidth: .infinity)
        }

    }
}

struct Sniglet_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RandomSnigletEV(entry: SnigletEntry(date: Date(), result: .empty()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            RandomSnigletEV(entry: SnigletEntry(date: Date(), result: .init(word: "hello", validation: "valid", confidence: 0.85)))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }

    }
}
