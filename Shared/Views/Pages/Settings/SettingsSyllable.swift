//
//  SettingsSyllable.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI

struct SettingsSyllableView: View {

    /// The list of custom syllable shapes to use in the algorithm.
    @AppStorage("customShapes") var customSyllables: SyllableShapes = SyllableShapes()

    /// The current custom syllable entry in the text field.
    @State private var customSyllableEntry: String = ""

    var body: some View {
        List {
            Section(footer: syllableFooter) {
                HStack {
                    TextField("settings.syllable.textprompt", text: $customSyllableEntry)
                        .textCase(.uppercase)
                        .font(.system(.body, design: .monospaced))
                    Button {
                        customSyllables.append(customSyllableEntry.toSyllableMarker())
                        customSyllableEntry = ""
                    } label: {
                        Text("settings.syllable.add")
                    }
                    .disabled(customSyllableEntry.isEmpty)
                }
            }

            Section {
                ForEach(customSyllables, id: \.self) { custom in
                    Text(custom)
                        .font(.system(.body, design: .monospaced))
                }
                .onDelete { indices in
                    indices.forEach { idx in customSyllables.remove(at: idx) }
                }
                ForEach(SyllableShapes.common(), id: \.self) { syl in
                    VStack(alignment: .leading) {
                        Text(syl)
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .monospaced))
                        Text("Common")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            } footer: {
                Text("settings.syllable.footer")
            }
        }
        .navigationTitle("settings.syllable.title")
        #if os(iOS)
        .toolbar {
            EditButton()
                .disabled(customSyllables.isEmpty)
        }
        #endif
    }

    /// The footer of the syllable shape section.
    var syllableFooter: some View {
        Group {
            if customSyllableEntry.count > 8 {
                Label {
                    Text("settings.syllable.limit")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                }
            } else if !customSyllableEntry.isMarker {
                Label("settings.syllable.convert", systemImage: "wand.and.stars")
            }
            else {
                Text("")
            }
        }
    }
}
