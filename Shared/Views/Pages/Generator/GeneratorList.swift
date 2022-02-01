//
//  GeneratorList.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import SwiftUI
import CoreData

/// A view that shows multiple sniglet entries at a time.
struct GeneratorList: View {

    /// The managed object context from the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateSize: Int = 1

    /// A list of sniglets generated by the network.
    @State var validateResults: [Sniglet.Result] = []

    /// Whether to display the explanation dialog.
    @State var showDetails: Bool = false

    /// The current sniglet that is selected.
    /// This is used to automatically select the first sniglet if necessary, such as on an iPad.
    @State var currentWord: String? = nil

    /// The current sniglet result.
    /// This becomes the data passed into the detail view when no sniglet is selected.
    @State var currentResult: Sniglet.Result = .empty()

    /// The primary body for the view.
    var body: some View {
        NavigationView {
            List {
                ForEach(validateResults) { result in
                    NavigationLink(destination: GeneratorListDetail(result: result)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.word)
                                .font(.system(.title2, design: .serif))
                                .bold()
                            Text("Confidence: \(result.confidence.asPercentage())%")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical)
                    .tag(result.word)
                    .contextMenu {
                        Button {
                            result.word.speak()
                        } label: {
                            Label("sound.button.prompt", systemImage: "speaker.wave.3")
                        }
                        Button {
                            let entry = SavedWord(context: managedObjectContext)
                            entry.word = result.word
                            entry.confidence = result.confidence
                            entry.validity = result.validation
                            entry.note = ""
                            DBController.shared.save()
                        } label: {
                            Label("saved.button.add", systemImage: "bookmark")
                        }
                    }
                }
            }
            .navigationTitle("generator.title")
            .onAppear(perform: setInitialState)
            .refreshable {
                updateState()
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: updateState) {
                        Label("generator.button.prompt", systemImage: "wand.and.stars")
                    }
                    .keyboardShortcut(.space, modifiers: [.shift])
                    .help("generator.button.prompt")
                }
            }

            if currentWord == nil {
                GeneratorListDetail(result: currentResult)
            }
        }
    }

    /// Sets the initial state for the view by generating sniglets.
    func setInitialState() {
        if !validateResults.isEmpty { return }
        validateResults = Sniglet.shared.getNewWords(count: generateSize).asArray()
        if let firstResult = validateResults.first {
            currentResult = firstResult
        }
    }

    /// Refreshes the view by generating sniglets.
    func updateState() {
        validateResults = Sniglet.shared.getNewWords(count: generateSize).asArray()
    }
}

/// A view that represents a detail that is provided when the user clicks on a sniglet.
struct GeneratorListDetail: View {

    /// The managed object context of the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// Whether the user has selected "Tap to Copy"
    @AppStorage("allowClipboard") var tapToCopy: Bool = true

    /// The current result that will be displayed in the detail.
    @State var result: Sniglet.Result

    /// Whether to show the explanation dialog.
    @State var showDetails: Bool = false

    /// Whether to display the alert that indicates a user has saved a sniglet to their dictionary.
    @State private var showAddedAlert: Bool = false

    /// The primary body for the view.
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            if tapToCopy {
                Button(action: { UIPasteboard.general.string = result.word }) {
                    GeneratorResultText(word: result.word)
                }
                .buttonStyle(.plain)
                Text("Tap the word to copy it to your clipboard.")
                    .font(.caption)
                    .foregroundColor(.secondary)

            } else {
                GeneratorResultText(word: result.word)
            }
            Spacer()
            GeneratorConfidence(confidence: result.confidence) {
                showDetails.toggle()
            }
        }
        .padding()
        .toolbar {
            ToolbarItem {
                if !tapToCopy {
                    Button(action: { UIPasteboard.general.string = result.word }) {
                        Label("Copy to Clipboard", systemImage: "doc.on.doc")
                    }
                }
            }

            ToolbarItem {
                Button {
                    result.word.speak()
                } label: {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }
            }
            
            ToolbarItem {
                Button(action: saveSniglet) {
                    Label("saved.button.add", systemImage: "bookmark")
                }
                .alert(
                    "saved.alert.title",
                    isPresented: $showAddedAlert,
                    actions: {
                        Button("OK", role: .cancel) { }
                    },
                    message: { Text("saved.alert.detail") }
                )
            }
        }
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
            }
        }
    }

    /// Save the entry to the database.
    func saveSniglet() {
        let entry = SavedWord(context: managedObjectContext)
        entry.word = result.word
        entry.confidence = result.confidence
        entry.validity = result.validation
        entry.note = ""
        DBController.shared.save()
        showAddedAlert = true
    }

}

struct GeneratorList_Preview: PreviewProvider {
    static var previews: some View {
        GeneratorList(generateSize: 5)
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad mini (6th generation)")
    }
}
