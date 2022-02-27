//
//  ContentView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 26/2/22.
//

import SwiftUI
import CoreData

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

                Label("saved.title", systemImage: "bookmark")
                Label("Customize", systemImage: "waveform")
            }
            .listStyle(.sidebar)

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
