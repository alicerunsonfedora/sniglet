//
//  Settings.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

/// A view that represents the settings page.
struct SettingsView: View {

    /// Whether the user had turned on "Tap to Copy"
    @AppStorage("allowClipboard") var allowCopying: Bool = true

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateBatches: Int = 1

    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    /// The number of batches at a given time to ensure that at least one valid sniglet appears.
    @AppStorage("algoBatchSize") var batchSize: Int = 25

    /// The list of custom syllable shapes to use in the algorithm.
    @AppStorage("customShapes") var customSyllables: SyllableShapes = SyllableShapes()

    /// The current custom syllable entry in the text field.
    @State private var customSyllableEntry: String = ""

    /// The current page the user is viewing.
    @State private var currentPage: Page? = nil

    /// The horizontal size class of the app: either compact or standard.
    /// This is used to determine whether the device is in landscape or if running on iPadOS and/or macOS.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// An enumeration for the different pages in the settings view.
    enum Page: String, Hashable {

        /// Stores the general settings.
        case general

        /// Stores the algorithm-specific settings.
        case algorithm

        /// Stores the syllable shapes settings.
        case syllable
    }


    /// The primary body for the view.
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

    /// The view to use when in portrait mode or for iPhones.
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

    /// The view to use when in landscape mode or for iPads/Macs.
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

    /// The general settings section.
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

    /// The batch size parameter sections.
    var batches: some View {
        Section(header: Text("settings.algorithm.batch.title"), footer: Text("settings.algorithm.batch.explain")) {
            Stepper(value: $batchSize, in: 5...Int.max, step: 5) {
                Label("\(batchSize) words", systemImage: "square.stack")
            }
        }
    }

    /// The word boundary section.
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

    /// The syllable shapes section.
    var syllables: some View {
        List {
            Section(footer: syllableFooter) {
                HStack {
                    TextField("settings.syllable.textprompt", text: $customSyllableEntry)
                        .textCase(.uppercase)
                        .font(.system(.body, design: .monospaced))
                    Button {
                        customSyllables.append(customSyllableEntry.toSyllableMarker())
                        customSyllableEntry = ""
                    } label: {
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

    /// The footer of the syllable shape section.
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
