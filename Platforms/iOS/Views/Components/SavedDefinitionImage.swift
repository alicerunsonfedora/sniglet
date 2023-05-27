//
//  SavedDefinitionImage.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 21/1/22.
//

import SwiftUI

struct SavedDefinitionImage: View {
    @State var entry: SavedWord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.word ?? "word")
                .font(.system(.title, design: .serif))
                .foregroundColor(.white)
                .bold()
            if let definition = entry.note {
                Text(definition)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.white)
            }
                Spacer()
            GeneratorConfidenceBar(confidence: entry.confidence)
                .frame(height: 8)
            Text("Confidence: \(entry.confidence.asPercentage())%")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white)
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

struct SavedDefinitionImage_Previews: PreviewProvider {
    static let previewCtx = DBController.preview
    static var previews: some View {
        SavedDefinitionImage(entry: DBController.preview.singleEntry())
            .environment(\.managedObjectContext, previewCtx.container.viewContext)
    }
}
