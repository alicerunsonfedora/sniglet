//
//  SharedSnigletImage.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 3/7/22.
//

import SwiftUI

struct SharedSnigletImage: View {
    var entry: Sniglet.Result

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.word)
                .font(.system(.title, design: .serif))
                .foregroundColor(.white)
                .bold()
            if let result = entry.confidence {
                Spacer()
                GeneratorConfidenceBar(confidence: result)
                    .frame(height: 8)
                Text("Confidence: \(result.asPercentage())%")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white)
            }
            Text("Generated with Give Me A Sniglet")
                .font(.system(.caption2, design: .serif))
                .foregroundColor(.white)
        }
        .preferredColorScheme(.dark)
        .padding(32)
        .background(
            Color(uiColor: .init(named: "SavedBackground") ?? .systemBackground)
        )
    }
}

struct SharedDefinitionImage_Previews: PreviewProvider {
    static let previewCtx = DBController.preview
    static var previews: some View {
        SharedSnigletImage(entry: .empty())
    }
}
