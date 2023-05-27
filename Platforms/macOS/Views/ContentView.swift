//
//  ContentView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 26/2/22.
//

import CoreData
import SwiftUI

struct ContentView: View {
    enum PageSelector {
        case generator
        case dictionary
        case algorithm
    }

    @State private var currentPage: PageSelector? = .generator

    var body: some View {
        NavigationSplitView {
            List(selection: $currentPage) {
                NavigationLink(value: PageSelector.generator) {
                    Label("generator.title", systemImage: "wand.and.stars")
                }
                NavigationLink(value: PageSelector.dictionary) {
                    Label("saved.title", systemImage: "bookmark")
                }
                NavigationLink(value: PageSelector.algorithm) {
                    Label("customize.title".fromMacLocale(), systemImage: "waveform")
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 175, idealWidth: 200)
            .navigationDestination(for: PageSelector.self) { page in
                switch page {
                case .dictionary:
                    DictionaryTableView()
                        .navigationTitle("saved.title")
                case .generator:
                    GeneratorTableView()
                        .navigationTitle("generator.title")
                case .algorithm:
                    CustomizePageView()
                        .navigationTitle("customize.title".fromMacLocale())
                }

            }
        } detail: {
            Group {
                if let currentPage {
                    switch currentPage {
                    case .dictionary:
                        DictionaryTableView()
                            .navigationTitle("saved.title")
                    case .generator:
                        GeneratorTableView()
                            .navigationTitle("generator.title")
                    case .algorithm:
                        CustomizePageView()
                            .navigationTitle("customize.title".fromMacLocale())
                    }
                } else {
                    Text("Give Me a Sniglet!")
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
