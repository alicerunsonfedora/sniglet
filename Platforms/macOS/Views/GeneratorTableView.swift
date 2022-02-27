//
//  GeneratorTableView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import SwiftUI
import CoreData

fileprivate typealias SResult = Sniglet.Result

struct GeneratorTableView: View {

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateSize: Int = 10

    /// The managed object context for the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var sniglets: [SResult] = []
    @State private var selection: SResult.ID? = nil
    @State private var sortOrder = [
        KeyPathComparator(\SResult.word),
        KeyPathComparator(\SResult.confidence)
    ]

    var body: some View {
        Group {
            if selection != nil {
                generatorTable
                    .toolbar {
                        selectionToolbar
                        refreshToolbarItem
                    }
            } else {
                generatorTable
                    .toolbar {
                        refreshToolbarItem
                    }
            }
        }
        .frame(minWidth: 300, idealWidth: 400, minHeight: 200, idealHeight: 300)
        .onAppear {
            Task {
                await updateList()
            }
        }
    }

    private var contextMenu: some View {
        Group {
            Button {
                copySelection()
            } label: {
                Label("generator.actions.copy".fromMacLocale(), systemImage: "doc.on.doc")
            }
            Button {
                getSelection()?.word.speak()
            } label: {
                Label("generator.actions.speak".fromMacLocale(), systemImage: "speaker.wave.3")
            }
            Button(action: saveSelection) {
                Label("generator.actions.save".fromMacLocale(), systemImage: "bookmark")
            }
        }

    }

    private var generatorTable: some View {
        Table(sniglets, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("table.sniglet".fromMacLocale(), value: \.word) { row in
                Text(row.word)
                    .contextMenu {
                        if selection != nil {
                            contextMenu
                        }
                    }
            }
            TableColumn("table.score".fromMacLocale(), value: \.confidence) { row in
                Text("\(row.confidence.asPercentage())%")
                    .font(.system(.body, design: .monospaced))
                    .contextMenu {
                        if selection != nil {
                            contextMenu
                        }
                    }
            }
            .width(min: 75, ideal: 100, max: 125)

        }
        .onChange(of: sortOrder) { sortOrder in
            sniglets.sort(using: sortOrder)
        }
    }

    private var refreshToolbarItem: some ToolbarContent {
        ToolbarItem {
            Button {
                Task {
                    await updateList()
                }
            } label: {
                Label("generator.actions.refresh".fromMacLocale(), systemImage: "arrow.clockwise")
            }
            .help("generator.help.refresh".fromMacLocale())
        }
    }

    private var selectionToolbar: some ToolbarContent {
        Group {
            ToolbarItem {
                Button {
                    copySelection()
                } label: {
                    Label("generator.actions.copy".fromMacLocale(), systemImage: "doc.on.doc")
                }
                .help("generator.help.copy".fromMacLocale())
            }
            ToolbarItem {
                Button {
                    getSelection()?.word.speak()
                } label: {
                    Label("generator.actions.speak".fromMacLocale(), systemImage: "speaker.wave.3")
                }
                .help("generator.help.speak".fromMacLocale())
            }
            ToolbarItem {
                Button(action: saveSelection) {
                    Label("generator.actions.save".fromMacLocale(), systemImage: "bookmark")
                }
                .help("generator.help.save".fromMacLocale())
            }
        }
    }

    private func updateList() async {
        sniglets = await Sniglet.shared.getNewWords(count: generateSize).asArray()
    }

    private func copySelection() {
        guard let result = getSelection() else {
            return
        }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(result.word, forType: .string)
    }

    private func getSelection() -> Sniglet.Result? {
        sniglets.first { sniglet in sniglet.id == selection }
    }

    private func saveSelection() {
        guard let result = getSelection() else {
            return
        }
        let entry = SavedWord(context: managedObjectContext)
        entry.word = result.word
        entry.confidence = result.confidence
        entry.validity = result.validation
        entry.note = ""
        DBController.shared.save()
    }
}

struct GeneratorTableView_Previews: PreviewProvider {
    static var previews: some View {
        GeneratorTableView()
    }
}
