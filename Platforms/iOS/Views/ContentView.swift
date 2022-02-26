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

    /// The current app build number.
    /// This is used to determine whether the "What's New" dialog needs to be displayed.
    @AppStorage("app-version") private var appVersion: String = ""

    /// Whether to show the "What's New" dialog on startup.
    @State private var showWhatsNew: Bool = false

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
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView {
                showWhatsNew.toggle()
            }
        }
        .onAppear {
            guard let curver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
            if appVersion != curver {
                showWhatsNew = true
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
