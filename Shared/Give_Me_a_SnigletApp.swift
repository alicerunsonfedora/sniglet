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

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, database.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            database.save()
        }
    }
}
