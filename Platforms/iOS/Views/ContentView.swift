//
//  ContentView.swift
//  Shared
//
//  Created by Marquis Kurt on 15/11/21.
//

import SwiftUI
import CoreML

/// The primary content view of the application.
struct ContentView: View {
    /// The primary body of the view.
    var body: some View {
        TabView {
            Generator()
            .tabItem {
                Label("generator.title", systemImage: "wand.and.stars")
            }

            Dictionary()
            .tabItem {
                Label("saved.title", systemImage: "character.book.closed")
            }

            SettingsView()
            .tabItem {
                Label("settings.title", systemImage: "gear")
            }
        }
        .frame(minWidth: 350, minHeight: 300)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
