//
//  GeneratorExplanation.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 8/5/22.
//

import SwiftUI

struct GeneratorExplanation: View {
    /// An action that executes when the user clicks "Done" or "Dismiss".
    var onDismiss: () -> Void

    /// The primary body for the view.
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 48) {
                Text("generator.explain.detail")
                    .padding(.horizontal)
                HStack(spacing: 8) {
                    Spacer()
                    letterNode("a")
                    letterNode("b")
                    letterNode("c")
                    letterNode("d")
                    letterNode("e")
                    ForEach(0 ..< 3) { _ in
                        letterNode("*")
                    }
                    Spacer()
                }
                Text("generator.explain.detail2")
                    .padding(.horizontal)
                Text("generator.explain.detail3")
                    .padding(.horizontal)
            }
            .font(.system(.body, design: .serif))
            #if os(macOS)
                .padding()
            #endif
            Spacer()
        }
        .navigationTitle("generator.explain.title")
        .toolbar {
            #if os(iOS)
                Button(action: onDismiss) {
                    Text("Dismiss")
                }
            #endif
        }
    }

    /// Returns a view that contains a single character.
    private func letterNode(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .font(.system(.title, design: .monospaced))
            .foregroundColor(.green)
            .frame(width: 36, height: 36)
            .background(Color.black)
            .cornerRadius(4)
    }
}

struct GeneratorExplainView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorExplanation {}
    }
}
