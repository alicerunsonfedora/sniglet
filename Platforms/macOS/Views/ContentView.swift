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
        NavigationView {
            List(selection: $currentPage) {
                NavigationLink(tag: PageSelector.generator, selection: $currentPage) {
                    GeneratorTableView()
                        .navigationTitle("generator.title")
                } label: {
                    Label("generator.title", systemImage: "wand.and.stars")
                }

                NavigationLink(tag: PageSelector.dictionary, selection: $currentPage) {
                    DictionaryTableView()
                        .navigationTitle("saved.title")
                } label: {
                    Label("saved.title", systemImage: "bookmark")
                }

                NavigationLink(tag: PageSelector.algorithm, selection: $currentPage) {
                    CustomizePageView()
                        .navigationTitle("customize.title".fromMacLocale())
                } label: {
                    Label("customize.title".fromMacLocale(), systemImage: "waveform")
                        .disabled(true)
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 175, idealWidth: 200)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        NSApp.keyWindow?.firstResponder?.tryToPerform(
                            #selector(NSSplitViewController.toggleSidebar(_:)),
                            with: nil
                        )
                    } label: {
                        Label("general.togglesidebar", systemImage: "sidebar.left")
                    }
                    .help("help.sidebar")
                }
            }

            Text("Give Me a Sniglet!")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
