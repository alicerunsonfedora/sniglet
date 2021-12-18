//
//  PersistentController.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 12/12/21.
//

import Foundation
import CoreData
import CloudKit

/// A structure responsible for calling the Core Data database to store save words.
struct DBController {

    /// An accessible, shared instance of the controller.
    static let shared = DBController()

    /// The `NSPersistentContainer` that hooks into Core Data.
    let container: NSPersistentCloudKitContainer

    /// A preview instance of the controller used in SwiftUI.
    static var preview: DBController = {
        let controller = DBController(inMemory: true)

        for _ in 0..<10 {
            let sniglet = Sniglet.shared.getNewWords().first ?? .null()
            let dictWord = SavedWord(context: controller.container.viewContext)
            dictWord.word = sniglet.word
            dictWord.confidence = sniglet.confidence
            dictWord.validity = sniglet.validation
            dictWord.note = "Lorem ipsum dolor si asmet."
        }

        return controller
    }()

    /// Create an instance of the database controller.
    /// - Parameter inMemory: Whether to only keep the database in memory. Defaults to false.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "DataModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Fatal Error: \(error.localizedDescription)")
            }
        }
    }

    func singleEntry() -> SavedWord {
        let word = SavedWord(context: container.viewContext)
        let sniglet = Sniglet.shared.getNewWords().first ?? .null()
        word.word = sniglet.word
        word.validity = sniglet.validation
        word.confidence = sniglet.confidence
        word.note = "Lorem ipsum dolor si amet."
        return word
    }

    /// Save changes from the controller into the database.
    func save() {
        let context = container.viewContext
        if !context.hasChanges { return }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
