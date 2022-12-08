//
//  DictionaryTable.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 12/8/22.
//

import Bunker
import CoreData
import SwiftUI

@available(iOS 16.0, *)
struct DictionaryTable: View {
    /// The managed object context for the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The fetch request that stores the saved sniglets.
    @FetchRequest(
        entity: SavedWord.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \SavedWord.word, ascending: true),
        ]
    )
    var words: FetchedResults<SavedWord>

    @State private var requestedShare: Bool = false
    @State private var selection: SavedWord.ID? = nil
    @State private var searchQuery = ""
    @State private var noteForSelection = ""
    @State private var promptEdit = false

    @State private var transferableContent: Either<Image, String>?

    var body: some View {
        Group {
            dictionaryTable
                .toolbar(id: "dictactions") {
                    selectionToolbar
                }
                .toolbarRole(.editor)
                .onChange(of: selection) { newValue in
                    Task { await updateTransferableContent() }
                }
        }
    }

    private var dictionaryTable: some View {
        Table(filterEntries(by: searchQuery), selection: $selection) {
            TableColumn("table.sniglet") { (row: SavedWord) in
                Text(row.word ?? "")
            }
            .width(min: 75, ideal: 125, max: 250)
            TableColumn("table.score") { (row: SavedWord) in
                Text("\(row.confidence.asPercentage())%")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .width(min: 75, ideal: 100, max: 125)
            TableColumn("table.note") { (row: SavedWord) in
                Text(row.note ?? "")
                    .foregroundColor(.secondary)
            }
        }
        .searchable(text: $searchQuery)
        .frame(minWidth: 550, idealWidth: 600, minHeight: 350, idealHeight: 450)
        .contextMenu(forSelectionType: SavedWord.ID.self) { selection in
            Button {
                getSelection()?.word?.speak()
            } label: {
                Label("sound.button.prompt", systemImage: "speaker.wave.3")
            }
            Button {
                promptEdit.toggle()
                noteForSelection = getSelection()?.note ?? ""
            } label: {
                Label("Set Note", systemImage: "square.and.pencil")
            }
            Button(role: .destructive) {
                deleteEntry()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Add a note", isPresented: $promptEdit) {
            TextField("Note", text: $noteForSelection)
            Button {
                getSelection()?.note = noteForSelection
                noteForSelection = ""
                DBController.shared.save()
            } label: {
                Text("Done")
            }
            Button(role: .cancel) {
                noteForSelection = ""
            } label: {
                Text("Cancel")
            }
        }
    }

    private var selectionToolbar: some CustomizableToolbarContent {
        Group {
            customizeToolbarItem(with: "speak") {
                Button {
                    getSelection()?.word?.speak()
                } label: {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }.disabled(selection == nil)
            }
            customizeToolbarItem(with: "edit") {
                Button {
                    promptEdit.toggle()
                    noteForSelection = getSelection()?.note ?? ""
                } label: {
                    Label("Set Note", systemImage: "square.and.pencil")
                }.disabled(selection == nil)
            }
            customizeToolbarItem(with: "delete") {
                Button(role: .destructive) {
                    deleteEntry()
                } label: {
                    Label("Delete", systemImage: "trash")
                }.disabled(selection == nil)
            }
            customizeToolbarItem(with: "share", primary: true) {
                Group {
                    switch transferableContent {
                    case .left(let image):
                        ShareLink(item: image, preview: .init("Generated Image", image: image))
                    case .right(let text):
                        ShareLink(item: text, subject: Text("Generated Text"))
                    case .none:
                        ShareLink(item: "")
                    }
                }
                .disabled(selection == nil)
            }
        }
    }

    private func deleteEntry() {
        withAnimation {
            if let currentWord = getSelection() {
                managedObjectContext.delete(currentWord)
                selection = nil
                DBController.shared.save()
            }
        }
    }

    private func filterEntries(by query: String) -> [SavedWord] {
        if searchQuery.isEmpty {
            return words.map { word in word }
        }
        return words.filter { word in
            word.word?.contains(query) == true
        }
    }

    private func getSelection() -> SavedWord? {
        words.first { word in word.id == selection }
    }

    private func updateTransferableContent() async {
        guard let sniglet = words.first(where: { $0.id == selection }) else { return }
        transferableContent = await getTransferableContent(for: sniglet)
    }

    private func getTransferableContent(for result: SavedWord) async -> Either<Image, String> {
        if shareMethod == "image", let image = ImageRenderer(content: SavedDefinitionImage(entry: result)).uiImage {
            return .left(Image(uiImage: image))
        }
        return .right(result.shareableText())
    }
}
