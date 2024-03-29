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

    enum PageState {
        case initial
        case loading
        case loaded
        case updated
    }

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

    @State private var pageState: PageState = .initial

    /// The primary body for the view.
    var body: some View {
        NavigationView {
            List {
                Group {
                    switch pageState {
                    case .initial, .loading:
                        ForEach(Array.init(repeating: Sniglet.Result.empty(), count: 5), id: \.id) { result in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.word)
                                    .font(.system(.title2, design: .serif))
                                    .bold()
                                Text("Confidence: \(result.confidence.asPercentage())%")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical)
                        }
                        .redacted(reason: .placeholder)
                    case .loaded, .updated:
                        generatedList
                    }
                }
            }
            .navigationTitle("generator.title")
            .onAppear(perform: setInitialState)
            .refreshable {
                withAnimation {
                    pageState = .loading
                    validateResults = []
                }
                Task {
                    await updateState()
                }
                withAnimation {
                    pageState = .updated
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        Task {
                            await updateState()
                        }
                    } label: {
                        Label("generator.button.prompt", systemImage: "wand.and.stars")
                    }
                    .keyboardShortcut(.space, modifiers: [.shift])
                    .help("generator.button.prompt")
                }
            }

            if currentWord == nil {
                if [PageState.loaded, PageState.updated].contains(pageState) {
                    GeneratorListDetail(result: currentResult)
                } else {
                    ProgressView()
                }
            }
        }
    }

    /// Sets the initial state for the view by generating sniglets.
    func setInitialState() {
        if !validateResults.isEmpty {
            pageState = .loaded
            return
        }
        withAnimation {
            pageState = .loading
            validateResults = Sniglet.shared.getNewWords(count: generateSize).asArray()
            if let firstResult = validateResults.first {
                currentResult = firstResult
            }
            pageState = .loaded
        }
    }

    /// Refreshes the view by generating sniglets.
    func updateState() async {
        validateResults = await Sniglet.shared.getNewWords(count: generateSize).asArray()
    }

    var generatedList: some View {
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
                TapToCopyButton(word: result.word)
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
                        Label("generator.copy.button", systemImage: "doc.on.doc")
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
            }
        }
        .toast(isPresented: $showAddedAlert, dismissAfter: 3.0) {
            ToastNotification("saved.alert.title", systemImage: "bookmark.fill", with: "saved.alert.detail")
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
        withAnimation(.easeInOut) {
            showAddedAlert = true
        }
    }

}

struct GeneratorList_Preview: PreviewProvider {
    static var previews: some View {
        GeneratorList(generateSize: 5)
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPad mini (6th generation)")
    }
}
