//
//  DictionaryTableView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import CoreData
import SwiftUI

struct DictionaryTableView: View {
    /// The managed object context for the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    @Environment(\.openURL) var openURL

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

    var body: some View {
        Group {
            if selection != nil {
                dictionaryTable
                    .toolbar {
                        selectionToolbar
                    }
            } else {
                dictionaryTable
            }
        }
        .navigationSubtitle(String(format: "subtitle.entries".fromMacLocale(), words.count))
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
        .contextMenu(forSelectionType: SavedWord.ID.self) { selection in
            contextMenu(for: selection)
        }
//        .searchable(text: $searchQuery)
//        .frame(minWidth: 550, idealWidth: 600, minHeight: 350, idealHeight: 450)
    }

    private func contextMenu(for selection: Set<SavedWord.ID>) -> some View {
        Group {
            Button {
                getSelection(from: selection.first)?.word?.speak()
            } label: {
                Label("generator.actions.speak".fromMacLocale(), systemImage: "speaker.wave.3")
            }
            .help("generator.help.speak".fromMacLocale())
            Button {
                if let url = URL(string: "sniglets://dictionary?id=\(getSelection(from: selection.first)?.objectID.uriRepresentation().absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                    openURL(url)
                }
            } label: {
                Label("dictionary.actions.edit".fromMacLocale(), systemImage: "square.and.pencil")
            }
            .help("dictionary.help.edit".fromMacLocale())
            Button {
                deleteEntry(with: selection.first)
            } label: {
                Label("dictionary.actions.delete".fromMacLocale(), systemImage: "trash")
            }
            .help("dictionary.help.delete".fromMacLocale())
        }
    }

    private var selectionToolbar: some ToolbarContent {
        Group {
            ToolbarItem {
                Button {
                    getSelection()?.word?.speak()
                } label: {
                    Label("generator.actions.speak".fromMacLocale(), systemImage: "speaker.wave.3")
                }
                .help("generator.help.speak".fromMacLocale())
            }
            ToolbarItem {
                Button {
                    if let url = URL(string: "sniglets://dictionary?id=\(getSelection()?.objectID.uriRepresentation().absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                        openURL(url)
                    }
                } label: {
                    Label("dictionary.actions.edit".fromMacLocale(), systemImage: "square.and.pencil")
                }
                .help("dictionary.help.edit".fromMacLocale())
            }
            ToolbarItem {
                Button {
                    requestedShare.toggle()
                } label: {
                    Label("dictionary.actions.share".fromMacLocale(), systemImage: "square.and.arrow.up")
                }
                .help("dictionary.help.share".fromMacLocale())
                .background(
                    SharingServicePicker(isPresented: $requestedShare, items: [getSelection()?.shareableText() as Any])
                )
            }
            ToolbarItem {
                Button {
                    deleteEntry()
                } label: {
                    Label("dictionary.actions.delete".fromMacLocale(), systemImage: "trash")
                }
                .help("dictionary.help.delete".fromMacLocale())
            }
        }
    }

    private func deleteEntry(with selectionID: SavedWord.ID? = nil) {
        withAnimation {
            if let currentWord = getSelection(from: selectionID) {
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

    private func getSelection(from requestedId: SavedWord.ID? = nil) -> SavedWord? {
        words.first { word in word.id == (requestedId ?? selection) }
    }
}

struct DictionaryTableView_Previews: PreviewProvider {
    static let previewCtx = DBController.preview

    static var previews: some View {
        DictionaryTableView()
            .environment(\.managedObjectContext, previewCtx.container.viewContext)
    }
}
