//
//  Give_Me_a_SnigletApp.swift
//  Shared
//
//  Created by Marquis Kurt on 15/11/21.
//

import SwiftUI

@main
struct Give_Me_a_SnigletApp: App {

    let database = DBController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, database.container.viewContext)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Reset Warnings") {
                    resetWarnings()
                }
            }
        }
    }

    private func resetWarnings() {
        UserDefaults.standard.set("", forKey: "app-version")
    }
}
