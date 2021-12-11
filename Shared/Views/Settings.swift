//
//  Settings.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

struct SettingsView: View {

    @AppStorage("allowClipboard") var allowCopying: Bool = true
    @AppStorage("generateSize") var generateBatches: Int = 1
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8
    @AppStorage("algoBatchSize") var batchSize: Int = 25
    @AppStorage("customShapes") var customSyllables: SyllableShapes = SyllableShapes()

    @State var customSyllableEntry: String = ""
    @State var currentPage: Page? = nil
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    enum Page: String, Hashable {
        case general
        case algorithm
        case syllable
    }

    var body: some View {
        NavigationView {
            if horizontalSizeClass == .compact {
                bodyPhone
            } else {
                bodyTablet
            }

            if currentPage == nil && horizontalSizeClass == .regular {
                List {
                    generalSettings
                }
                .navigationTitle("settings.general.title")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.insetGrouped)
            }
        }
    }

    var bodyPhone: some View {
        List {
            generalSettings
            boundaries
            batches
            NavigationLink(destination: { syllables }) {
                Label("settings.syllable.title", systemImage: "quote.closing")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("settings.title")
    }

    var bodyTablet: some View {
        List(selection: $currentPage) {
            NavigationLink(destination: {
                    List {
                        generalSettings
                    }
                    .navigationTitle("settings.general.title")
                    .navigationBarTitleDisplayMode(.inline)
            }) {
                Label("settings.general.title", systemImage: "gear")
            }
            .tag(Page.general)
            Section(header: Text("Generation")) {
                NavigationLink(destination: {
                    List {
                        boundaries
                        batches
                    }
                    .navigationTitle("settings.algorithm.title")
                    .navigationBarTitleDisplayMode(.inline)
                }) {
                    Label("settings.algorithm.title", systemImage: "waveform")
                }
                .tag(Page.algorithm)
                NavigationLink(destination: { syllables.navigationBarTitleDisplayMode(.inline)
                }) {
                    Label("settings.syllable.title", systemImage: "quote.closing")
                }
                .tag(Page.syllable)
            }
            #if os(macOS)
            .collapsible(false)
            #endif
        }
        .navigationTitle("settings.title")
        .listStyle(.sidebar)
    }

    var generalSettings: some View {
        Section(header: Text("settings.general.title"), footer: Text("settings.clipboard.footer")) {
            Stepper(value: $generateBatches, in: 1...Int.max) {
                Label("Generate \(generateBatches) words", systemImage: "sparkles.rectangle.stack.fill")
            }
            Toggle(isOn: $allowCopying) {
                Label("settings.clipboard.name", systemImage: "doc.on.clipboard")
            }
        }
    }

    var batches: some View {
        Section(header: Text("settings.algorithm.batch.title"), footer: Text("settings.algorithm.batch.explain")) {
            Stepper(value: $batchSize, in: 5...Int.max, step: 5) {
                Label("\(batchSize) words", systemImage: "square.stack")
            }
        }
    }

    var boundaries: some View {
        Section(header: Text("settings.algorithm.boundaries.title"), footer: Text("settings.algorithm.boundaries.explain")) {
            Stepper(value: $minGenerationValue, in: 3...maxGenerationValue) {
                Label("Min: \(minGenerationValue) letters", systemImage: "smallcircle.filled.circle")
            }
            Stepper(value: $maxGenerationValue, in: minGenerationValue...8) {
                Label("Max: \(maxGenerationValue) letters", systemImage: "circle.circle.fill")
            }
        }
    }

    var syllables: some View {
        List {
            Section(footer: syllableFooter) {
                HStack {
                    TextField("settings.syllable.textprompt", text: $customSyllableEntry)
                        .textCase(.uppercase)
                        .font(.system(.body, design: .monospaced))
                    Button(action: {
                        customSyllables.append(customSyllableEntry.toSyllableMarker())
                        customSyllableEntry = ""
                    }) {
                        Text("settings.syllable.add")
                    }
                    .disabled(customSyllableEntry.isEmpty)
                }
            }



            Section(footer: Text("settings.syllable.footer")) {
                ForEach(customSyllables, id: \.self) { custom in
                    Text(custom)
                        .font(.system(.body, design: .monospaced))
                }
                .onDelete { indices in
                    indices.forEach { idx in customSyllables.remove(at: idx) }
                }
                ForEach(SyllableShapes.common(), id: \.self) { syl in
                    VStack(alignment: .leading) {
                        Text(syl)
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .monospaced))
                        Text("Common")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
        }
        .navigationTitle("settings.syllable.title")
        #if os(iOS)
        .toolbar {
            EditButton()
                .disabled(customSyllables.isEmpty)
        }
        #endif
    }

    var syllableFooter: some View {
        Group {
            if customSyllableEntry.count > 8 {
                Label {
                    Text("settings.syllable.limit")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                }
            } else if !customSyllableEntry.isMarker {
                Label("settings.syllable.convert", systemImage: "wand.and.stars")
            }
            else {
                Text("")
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice("iPhone 13")
            NavigationView {
                SettingsView().syllables
            }
                .previewDevice("iPhone 13")
            SettingsView()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
