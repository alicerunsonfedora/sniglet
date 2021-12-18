//
//  GeneratorSingle.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import CoreData
import SwiftUI

struct GeneratorSingleView: View {
    @AppStorage("allowClipboard") var tapToCopy: Bool = true
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var result: Sniglet.Result = .empty()
    @State var showDetails: Bool = false
    @State private var showAddedAlert: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
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
            Spacer()
            if tapToCopy {
                Button(action: { UIPasteboard.general.string = result.word }) {
                    GeneratorResultText(word: result.word)
                }
                .buttonStyle(.plain)
            } else {
                GeneratorResultText(word: result.word)
            }

            Button(action: setSniglet) {
                Label("generator.button.prompt", systemImage: "wand.and.stars")
            }

            .buttonStyle(.borderedProminent)
            #if os(iOS)
            .cornerRadius(16)
            #endif

            if tapToCopy {
                Text("generator.copy.prompt")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            GeneratorConfidence(confidence: result.confidence) {
                showDetails.toggle()
            }

        }
        .onAppear(perform: setSniglet)
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
            }
        }
        .padding()
    }

    func setSniglet() {
        result = Sniglet.shared.getNewWords().first ?? .null()
    }

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

struct GeneratorSingle_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            GeneratorSingleView()
                .previewDevice("iPhone 13")
        }
    }
}
