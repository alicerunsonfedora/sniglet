//
//  Give_Me_a_SnigletApp.swift
//  Watch WatchKit Extension
//
//  Created by Marquis Kurt on 1/2/22.
//

import SwiftUI

@main
struct SnigletWatchApp: App {

    let database = DBController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, database.container.viewContext)
            }
        }
    }
}
