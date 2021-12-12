//
//  GeneratorList.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import SwiftUI

struct GeneratorList: View {
    @AppStorage("generateSize") var generateSize: Int = 1
    @State var validateResults: [Sniglet.Result] = []
    @State var showDetails: Bool = false
    @State var currentWord: String? = nil
    @State var currentResult: Sniglet.Result = .empty()

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

    func setInitialState() {
        if !validateResults.isEmpty { return }
        validateResults = Sniglet.shared.getNewWords(count: generateSize).asArray()
        if let firstResult = validateResults.first {
            currentResult = firstResult
        }
    }

    func updateState() {
        validateResults = Sniglet.shared.getNewWords(count: generateSize).asArray()
    }
}

struct GeneratorListDetail: View {

    @AppStorage("allowClipboard") var tapToCopy: Bool = true
    @State var result: Sniglet.Result
    @State var showDetails: Bool = false

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
        }
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
            }
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
