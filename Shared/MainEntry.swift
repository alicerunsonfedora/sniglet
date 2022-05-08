//
//  MainEntry.swift
//  Shared
//
//  Created by Marquis Kurt on 15/11/21.
//

import SwiftUI

/// The main entry point of the application.
@main
struct SnigletApp: App {

    /// The shared database that the app will use to store saved sniglets.
    let database = DBController.shared

    #if os(macOS)
    @State private var editedUrl: String = ""
    #endif

    /// The main body of the application.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, database.container.viewContext)
            #if os(macOS)

            #endif
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("settings.reset.title") {
                    resetWarnings()
                }
            }
        }

        #if os(macOS)
        WindowGroup {
            CustomizeSyllablesView()
        }
        .handlesExternalEvents(matching: ["syllables"])

        WindowGroup {
            GeneratorExplanation() { }
                .navigationSubtitle("Give Me a Sniglet")
                .toolbar {
                    Spacer()
                }
        }
        .handlesExternalEvents(matching: ["help"])

        WindowGroup {
            DictionaryEditorView(entryID: $editedUrl)
                .handlesExternalEvents(preferring: ["dictionary"], allowing: ["dictionary"])
                .environment(\.managedObjectContext, database.container.viewContext)
                .onOpenURL { url in

                    if let params = url.queryParameters() {
                        guard let id = params["id"] else {
                            editedUrl = ""
                            return
                        }
                        guard let objectURL = URL(string: id ?? "") else {
                            editedUrl = ""
                            return
                        }
                        editedUrl = objectURL.absoluteString
                        print(editedUrl)
                    }


                }
                .onDisappear {
                    editedUrl = ""
                }
        }
        .handlesExternalEvents(matching: ["dictionary"])
        #endif
    }

    /// Reset dialogs and warnings.
    private func resetWarnings() {
        UserDefaults.standard.set("", forKey: "app-version")
    }
}
