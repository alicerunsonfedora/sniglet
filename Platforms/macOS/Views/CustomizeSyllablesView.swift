//
//  CustomizeSyllablesView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/4/22.
//

import SwiftUI

struct CustomizeSyllablesView: View {

    /// The list of custom syllable shapes to use in the algorithm.
    @AppStorage("customShapes") var customSyllables: SyllableShapes = SyllableShapes()

    @State private var syllableSelection: Set<String> = .init()

    @State private var syllableString = ""

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("", text: $syllableString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    withAnimation {
                        customSyllables.append(syllableString.toSyllableMarker())
                    }
                } label: {
                    Text("Add")
                        .frame(minWidth: 75)
                }
            }
            syllableFooter

            Spacer()

            List(customSyllables + SyllableShapes.common(), id: \.self, selection: $syllableSelection) { shape in
                Text(shape)
                    .foregroundColor(
                        SyllableShapes.common().contains(shape) ? .secondary : .primary
                    )
                    .contextMenu {
                        Button {
                            withAnimation {
                                deleteSelectedItems()
                            }
                        } label: {
                            Text(
                                String(format: "customize.syllables.delete".fromMacLocale(), syllableSelection.count)
                            )
                        }
                        .disabled(SyllableShapes.common().contains(shape))
                    }
            }
            .listStyle(.inset(alternatesRowBackgrounds: true))


            Text("settings.syllable.footer")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(minWidth: 300, minHeight: 250)
        .navigationTitle("settings.syllable.title")
    }

    var syllableFooter: some View {
        Group {
            if syllableString.count > 8 {
                Label {
                    Text("settings.syllable.limit")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.yellow)
                }
            } else if !syllableString.isMarker {
                Label("settings.syllable.convert", systemImage: "wand.and.stars")
            }
            else {
                Text("")
            }
        }
    }

    private func deleteSelectedItems() {
        for shape in syllableSelection {
            guard let idx = customSyllables.firstIndex(of: shape) else { continue }
            customSyllables.remove(at: idx)
        }
    }
}

struct CustomizeSyllablesView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeSyllablesView()
    }
}
