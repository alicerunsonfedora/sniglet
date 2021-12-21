//
//  Give_Me_a_SnigletApp.swift
//  Shared
//
//  Created by Marquis Kurt on 15/11/21.
//

import SwiftUI

/// The main entry point of the application.
@main
struct Give_Me_a_SnigletApp: App {

    /// The shared database that the app will use to store saved sniglets.
    let database = DBController.shared

    /// The main body of the application.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, database.container.viewContext)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Reset Dialogs") {
                    resetWarnings()
                }
            }
        }
    }

    /// Reset dialogs and warnings.
    private func resetWarnings() {
        UserDefaults.standard.set("", forKey: "app-version")
    }
}
