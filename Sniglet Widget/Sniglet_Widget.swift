//
//  Sniglet_Widget.swift
//  Sniglet Widget
//
//  Created by Marquis Kurt on 30/11/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SnigletEntry {
        SnigletEntry(date: Date(), result: .empty())
    }

    func getSnapshot(in context: Context, completion: @escaping (SnigletEntry) -> ()) {
        var result = Sniglet.shared.getNewWords(count: 1)
        let entry = SnigletEntry(date: Date(), result: result.removeFirst())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SnigletEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        var results = Sniglet.shared.getNewWords(count: 5)
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SnigletEntry(date: entryDate, result: results.removeFirst())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SnigletEntry: TimelineEntry {
    let date: Date
    let result: Sniglet.Result
}

struct Sniglet_WidgetConfidenceBar: View {
    var condifence: Double

    var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.white)
                    .opacity(0.1)
                    .frame(width: geom.size.width, height: geom.size.height)
                LinearGradient(
                    colors: [.purple, .indigo, .blue, .cyan, .teal],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .mask(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.accentColor)
                            .frame(width: geom.size.width * condifence, height: geom.size.height)
                    }
            }
            .cornerRadius(geom.size.height / 2)
        }
        .frame(minHeight: 2)
    }
}

struct Sniglet_WidgetEntryView : View {
    var entry: Provider.Entry

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
                Sniglet_WidgetConfidenceBar(condifence: entry.result.confidence)
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

@main
struct Sniglet_Widget: Widget {
    let kind: String = "Sniglet_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Sniglet_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random Sniglet")
        .description("View a random sniglet.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct Sniglet_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Sniglet_WidgetEntryView(entry: SnigletEntry(date: Date(), result: .empty()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Sniglet_WidgetEntryView(entry: SnigletEntry(date: Date(), result: .init(word: "hello", validation: "valid", confidence: 0.85)))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }

    }
}
