//
//  GeneratorSingle.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import SwiftUI

struct GeneratorSingleView: View {
    @AppStorage("allowClipboard") var tapToCopy: Bool = true
    @State var result: Sniglet.Result = .empty()
    @State var showDetails: Bool = false

    var body: some View {
        VStack(spacing: 16) {
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
                Text("Tap the word to copy it to your clipboard.")
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

}

struct GeneratorSingle_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            GeneratorSingleView()
                .previewDevice("iPhone 13")
        }
    }
}
