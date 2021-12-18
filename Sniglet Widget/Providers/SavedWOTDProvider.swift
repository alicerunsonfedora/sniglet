//
//  SavedWOTDProvider.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import Foundation
import WidgetKit
import CoreData

struct SavedWOTDProvider: TimelineProvider {

    var managedObjectContext: NSManagedObjectContext
    var previewMOC: NSManagedObjectContext

    let fetchRequest = NSFetchRequest<SavedWord>(entityName: "SavedWord")

    func placeholder(in context: Context) -> SavedWordEntry {
        let dummyEntry = SavedWord(context: previewMOC)
        dummyEntry.word = "word"
        dummyEntry.confidence = 0.42
        dummyEntry.validity = "valid"
        dummyEntry.note = "A sequence of morphemes with a specified meaning"
        return SavedWordEntry(date: Date(), word: dummyEntry)
    }

    func getSnapshot(in context: Context, completion: @escaping (SavedWordEntry) -> Void) {
        let fetchRequest = NSFetchRequest<SavedWord>(entityName: "SavedWord")
        do {
            guard let word = try managedObjectContext.fetch(fetchRequest).randomElement() else {
                completion(placeholder(in: context))
                return
            }
            completion(SavedWordEntry(date: Date(), word: word))
        } catch {
            completion(placeholder(in: context))
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SavedWordEntry>) -> Void) {
        var entries = [SavedWordEntry]()
        let currentDate = Date()
        let fetchRequest = NSFetchRequest<SavedWord>(entityName: "SavedWord")

        do {
            let words = try managedObjectContext.fetch(fetchRequest)

            for dayOffset in 0..<5 {
                let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
                if let randomSniglet = words.randomElement() {
                    entries.append(SavedWordEntry(date: date, word: randomSniglet))
                }
            }
        } catch {
            entries.append(placeholder(in: context))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SavedWordEntry: TimelineEntry {
    let date: Date
    let word: SavedWord
}
