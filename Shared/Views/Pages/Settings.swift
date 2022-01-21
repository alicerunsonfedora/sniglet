//
//  Settings.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

/// A view that represents the settings page.
struct SettingsView: View {

    // MARK: - App Storage

    /// Whether the user had turned on "Tap to Copy"
    @AppStorage("allowClipboard") var allowCopying: Bool = true

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateBatches: Int = 1

    /// The validation model to use.
    @AppStorage("generateMethod") var generateMethod: String = "Classic"

    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    /// The number of batches at a given time to ensure that at least one valid sniglet appears.
    @AppStorage("algoBatchSize") var batchSize: Int = 25

    /// The list of custom syllable shapes to use in the algorithm.
    @AppStorage("customShapes") var customSyllables: SyllableShapes = SyllableShapes()

    // MARK: - State Variables

    /// The current custom syllable entry in the text field.
    @State private var customSyllableEntry: String = ""

    /// The current page the user is viewing.
    @State private var currentPage: Page? = nil

    /// The validation model to use.
    /// This is used in the picker. To store into User Defaults, refer to `generateMethod`.
    @State private var genMethodEnum: ValidatorKind = .Classic

    /// Whether to display the Safari view used for opening the feedback/licensing pages.
    @State private var showSafariView: Bool = false

    /// The link to use.
    @State private var safariLink: AppLink = .none

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

    // MARK: - Main Body

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
                    informationSection
                }
                .navigationTitle("settings.general.title")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.insetGrouped)
            }
        }
        .onAppear {
            genMethodEnum = ValidatorKind(rawValue: generateMethod) ?? .Classic
            showSafariView = false
        }
        .onChange(of: genMethodEnum) { value in
            generateMethod = value.rawValue
        }
        .sheet(isPresented: $showSafariView) {
            VStack {
                SettingsSafariWindow(link: $safariLink)
            }
        }
    }

    // MARK: - Body Variants

    /// The view to use when in portrait mode or for iPhones.
    var bodyPhone: some View {
        List {
            generalSettings
            generationSection

            NavigationLink {
                informationSection
                    .navigationTitle("settings.info.title")
            } label: {
                Label("settings.info.title", systemImage: "info.circle")
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
                        informationSection
                    }
                    .navigationTitle("settings.general.title")
                    .navigationBarTitleDisplayMode(.inline)
            }) {
                Label("settings.general.title", systemImage: "gear")
            }
            .tag(Page.general)
            generationSection
        }
        .navigationTitle("settings.title")
        .listStyle(.sidebar)
    }

    // MARK: - General Settings

    /// The general settings section.
    var generalSettings: some View {
        Group {
            Section {
                Stepper(value: $generateBatches, in: 1...Int.max) {
                    Label("Generate \(generateBatches) words", systemImage: "sparkles.rectangle.stack.fill")
                }
                Toggle(isOn: $allowCopying) {
                    Label("settings.clipboard.name", systemImage: "doc.on.clipboard")
                }
            } header: {
                Text("settings.general.title")
            } footer: {
                Text("settings.clipboard.footer")
            }
        }
    }

    // MARK: - Generation and Batches

    /// The generation settings section.
    var generationSection: some View {
        Section {
            NavigationLink(destination: {
                List {
                    boundaries
                    batches
                    generationMethod
                }
                .navigationTitle("settings.algorithm.title")
                .navigationBarTitleDisplayMode(.inline)
            }) {
                Label("settings.algorithm.title", systemImage: "waveform")
            }
            .tag(Page.algorithm)
            NavigationLink {
                syllables.navigationBarTitleDisplayMode(.inline)
            } label: {
                Label("settings.syllable.title", systemImage: "quote.closing")
            }
            .tag(Page.syllable)
        } header: {
            Text("Generation")
        }
    }

    /// The batch size parameter sections.
    var batches: some View {
        Section {
            Stepper(value: $batchSize, in: 5...Int.max, step: 5) {
                Label("\(batchSize) words", systemImage: "square.stack")
            }
        } header: {
            Text("settings.algorithm.batch.title")
        } footer: {
            Text("settings.algorithm.batch.explain")
        }
    }

    /// The word boundary section.
    var boundaries: some View {
        Section {
            Stepper(value: $minGenerationValue, in: 3...maxGenerationValue) {
                Label("Min: \(minGenerationValue) letters", systemImage: "smallcircle.filled.circle")
            }
            Stepper(value: $maxGenerationValue, in: minGenerationValue...8) {
                Label("Max: \(maxGenerationValue) letters", systemImage: "circle.circle.fill")
            }
        } header: {
            Text("settings.algorithm.boundaries.title")
        } footer: {
            Text("settings.algorithm.boundaries.explain")
        }
    }

    /// The section dedicated to selecting the validation model.
    var generationMethod: some View {
        Section {
            Picker("settings.algorithm.model.picker", selection: $genMethodEnum) {
                ForEach(ValidatorKind.allCases, id: \.self) { kind in
                    Text(kind.rawValue)
                        .tag(kind)
                }

            }
            .disabled(true) // TODO: Enable this when ready.
        } header: {
            Text("settings.algorithm.model.title")
        } footer: {
            Text("settings.algorithm.model.explain")
        }
    }

    // MARK: - App Information

    /// The section dedicated to displaying app information such as its version.
    var informationSection: some View {
        Group {
            Section {
                HStack {
                    Text("settings.info.version")
                    Spacer()
                    Text(getAppVersion())
                        .foregroundColor(.secondary)
                }
                Button {
                    showSafariWindow(to: .license)
                } label: {
                    HStack {
                        Text("License")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("MPLv2")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("settings.info.header")
            } footer: {
                Text("settings.info.footer")
            }

            Section {
                Button {
                    showSafariWindow(to: .feedback)
                } label: {
                    Label("settings.info.feedback", systemImage: "exclamationmark.bubble")
                }
                Link(
                    destination: URL(string: AppLink.source.rawValue)!
                ) {
                    Label("settings.info.source", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }
        }

    }

    // MARK: - Syllable Shapes

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

    // MARK: - Methods

    /// Show the in-app Safari window and open the corresponding link.
    /// - Parameter link: The app link to open in the Safari in-app browser.
    private func showSafariWindow(to link: AppLink) {
        safariLink = link
        showSafariView.toggle()
    }

}

// MARK: - Previews

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice("iPhone 13")
            NavigationView {
                List {
                    SettingsView().boundaries
                    SettingsView().batches
                    SettingsView().generationMethod
                }
                .navigationTitle("settings.algorithm.title")
            }
                .previewDevice("iPhone 13")
            NavigationView {
                SettingsView().syllables
            }
                .previewDevice("iPhone 13")
            NavigationView {
                List {
                    SettingsView().informationSection
                        .navigationTitle("settings.info.title")
                }
            }
                .previewDevice("iPhone 13")
            SettingsView()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
