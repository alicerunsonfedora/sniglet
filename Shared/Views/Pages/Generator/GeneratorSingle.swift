//
//  GeneratorSingle.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import CoreData
import SwiftUI
import AVFoundation

/// A view that represents the single generation view.
struct GeneratorSingleView: View {

    /// Whether the user has turned on "Tap to Copy"
    @AppStorage("allowClipboard") var tapToCopy: Bool = true

    /// The managed object context for the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// The current generated sniglet.
    @State var result: Sniglet.Result = .empty()

    /// Whether to show the explanation dialog.
    @State var showDetails: Bool = false

    /// Whether to display an alert that indicates the user has saved the sniglet to their dictionary.
    @State private var showAddedAlert: Bool = false


    /// The primary body for the view.
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                HStack(spacing: 24) {
                    Button {
                        result.word.speak()
                    } label: {
                        Label("sound.button.prompt", systemImage: "speaker.wave.3")
                    }
                    Button(action: saveSniglet) {
                        Label("saved.button.add", systemImage: "bookmark")
                    }
                }
                .labelStyle(.iconOnly)
            }
            Spacer()
            if tapToCopy {
                TapToCopyButton(word: result.word)
            } else {
                GeneratorResultText(word: result.word)
            }

            Button {
                Task {
                    await setSniglet()
                }
            } label: {
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
        .toast(isPresented: $showAddedAlert, dismissAfter: 3.0) {
            ToastNotification("saved.alert.title", systemImage: "bookmark.fill", with: "saved.alert.detail")
        }
        .onAppear {
            Task {
                await setSniglet()
            }
        }
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
            }
        }
        .padding()
    }

    /// Sets the result to a generated sniglet.
    func setSniglet() async {
        result = await Sniglet.shared.getNewWords().first ?? .null()
    }

    /// Saves the sniglet to the user's dictionary.
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

struct GeneratorSingle_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            GeneratorSingleView()
                .previewDevice("iPhone 13")
        }
    }
}
