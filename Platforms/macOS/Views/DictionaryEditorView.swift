//
//  DictionaryEditorView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 8/5/22.
//

import SwiftUI

struct DictionaryEditorView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.openURL) var openURL

    @State var entryID: Binding<String>

    @State private var entry: SavedWord?
    @State private var definition: String = ""
    @State private var showHelp: Bool = false
    @State private var requestedShare: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(entry?.word ?? "")
                    .font(.system(.largeTitle, design: .serif))
                    .bold()
                Spacer()
                Text("\(entry?.confidence.asPercentage() ?? 0)%")
                    .font(.system(.title, design: .monospaced))
                HelpButton {
                    if let url = URL(string: "sniglets://help") {
                        openURL(url)
                    }
                }
                .font(.title2)
                .padding(.trailing, 2)
            }
            TextEditor(text: $definition)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .onChange(of: definition) { value in
                    definition = value
                    entry?.note = value
                    DBController.shared.save()
                }
        }
        .padding()
        .navigationTitle(entry?.word ?? "Sniglet")
        .navigationSubtitle("saved.title")
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            Task {
                setupEntry()
                if let note = entry?.note {
                    definition = note
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    entry?.word?.speak()
                } label: {
                    Label("generator.actions.speak".fromMacLocale(), systemImage: "speaker.wave.3")
                }
                .help("generator.help.speak".fromMacLocale())
            }
            ToolbarItem {
                Button {
                    requestedShare.toggle()
                } label: {
                    Label("dictionary.actions.share".fromMacLocale(), systemImage: "square.and.arrow.up")
                }
                .help("dictionary.help.share".fromMacLocale())
                .background(
                    SharingServicePicker(isPresented: $requestedShare, items: [entry?.shareableText() as Any])
                )
            }
        }
    }

    private func setupEntry() {
        let url = entryID.wrappedValue
        guard let objectURL = URL(string: url) else { return }
        if let objID = DBController.shared.container.persistentStoreCoordinator
            .managedObjectID(forURIRepresentation: objectURL)
        {
            do {
                entry = try managedObjectContext
                    .existingObject(with: objID) as? SavedWord
            } catch {
                print("ERR: Failed to get Object ID.")
            }
        }
    }
}

// struct DictionaryEditorView_Previews: PreviewProvider {
//    static let previewCtx = DBController.preview
//
//    static var previews: some View {
//        DictionaryEditorView(entry: .constant(previewCtx.singleEntry()))
//    }
// }
