//
//  ContentView.swift
//  Shared
//
//  Created by Marquis Kurt on 15/11/21.
//

import SwiftUI
import CoreML

struct ContentView: View {

    @AppStorage("app-version") var appVersion: String = ""
    @State var showWhatsNew: Bool = false

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
