//
//  RandomSnigletProvider.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import WidgetKit

struct RandomSnigletProvider: TimelineProvider {
    func placeholder(in context: Context) -> SnigletEntry {
        SnigletEntry(date: Date(), result: .empty())
    }

    func getSnapshot(in context: Context, completion: @escaping (SnigletEntry) -> ()) {
        var result = Sniglet.shared.getNewWords(count: 1)
        let entry = SnigletEntry(date: Date(), result: result.removeFirst())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SnigletEntry>) -> ()) {
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
