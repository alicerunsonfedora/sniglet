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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    enum PageSelector {
        case generator
        case dictionary
        case generalSettings
        case algorithmSettings
        case syllableShapeSettings
    }

    @State private var currentPage: PageSelector? = .generator

    /// The primary body of the view.
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                regularLayout
            } else {
                compactLayout
            }
        }
    }

    @available(iOS 16.0, *)
    private var regularLayout: some View {
        NavigationView {
            List(selection: $currentPage) {
                NavigationLink(tag: PageSelector.generator, selection: $currentPage) {
                    GeneratorTable()
                        .navigationTitle("generator.title")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Label("generator.title", systemImage: "wand.and.stars")
                }
                NavigationLink(tag: PageSelector.dictionary, selection: $currentPage) {
                    DictionaryTable()
                        .navigationTitle("saved.title")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Label("saved.title", systemImage: "character.book.closed")
                }
                settingsLinks
                NavigationLink {
                    List { SettingsAboutView() }
                        .navigationTitle("settings.info.title")
                } label: {
                    Label("settings.info.title", systemImage: "info.circle")
                }
            }
            .navigationTitle("Give Me a Sniglet")
            Text("Give Me a Sniglet!")
                .padding()
        }
    }

    private var compactLayout: some View {
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

    private var settingsLinks: some View {
        Section {
            NavigationLink {
                List {
                    SettingsGeneralView()
                }
                .listStyle(.insetGrouped)
                .navigationTitle("settings.title")
            } label: {
                Label("settings.general.title", systemImage: "gear")
            }

            NavigationLink {
                List {
                    SettingsGenerationBoundarySliderSegment()
                    SettingsGenerationBatchSegment()

                    // TODO: Re-enable the settings page for the Generation Method once the models are ready.
                    // SettingsGenerationMethodSegment()
                }
                .navigationTitle("settings.algorithm.title")
            } label: {
                Label("settings.algorithm.title", systemImage: "waveform")
            }
            .tag(SettingsView.Page.algorithm)
            NavigationLink {
                SettingsSyllableView()
            } label: {
                Label("settings.syllable.title", systemImage: "quote.closing")
            }
            .tag(SettingsView.Page.syllable)
        } header: {
            Text("settings.title")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
