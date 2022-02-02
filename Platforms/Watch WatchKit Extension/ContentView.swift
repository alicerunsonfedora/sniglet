//
//  ContentView.swift
//  Watch WatchKit Extension
//
//  Created by Marquis Kurt on 1/2/22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    /// The managed object context from the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// The current generated sniglet.
    @State private var sniglet: Sniglet.Result = .empty()

    /// Whether this sniglet was just saved into iCloud.
    @State private var saved: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Spacer()

            Text(sniglet.word)
                .font(.system(.title2, design: .serif))
                .bold()
                .onTapGesture {
                    withAnimation {
                        saved = false
                        sniglet = Sniglet.shared.getNewWords().first!
                    }
                }
                .onLongPressGesture {
                    withAnimation {
                        saveSniglet()
                    }
                }

            Text("Tap to regenerate, or tap and hold to save.")
                .font(.system(.footnote, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
            VStack(spacing: 4) {
                if saved {
                    Label("Saved", systemImage: "checkmark")
                        .font(.footnote)
                        .foregroundColor(.green)
                } else {
                    Text("Confidence: \(sniglet.confidence.asPercentage())%")
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            saved = false
            sniglet = Sniglet.shared.getNewWords().first!
        }
    }

    private func saveSniglet() {
        let entry = SavedWord(context: managedObjectContext)
        entry.word = sniglet.word
        entry.confidence = sniglet.confidence
        entry.validity = sniglet.validation
        entry.note = ""
        DBController.shared.save()
        saved = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DBController.preview.container.viewContext)
    }
}
