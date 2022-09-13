//
//  GeneratorTableView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import CoreData
import SwiftUI

private typealias SResult = Sniglet.Result

struct GeneratorTableView: View {
    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateSize: Int = 10

    /// The managed object context for the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var requestedShare = false
    @State private var sniglets: [SResult] = []
    @State private var selection: SResult.ID? = nil
    @State private var sortOrder = [
        KeyPathComparator(\SResult.word),
        KeyPathComparator(\SResult.confidence),
    ]

    var body: some View {
        Group {
            if selection != nil {
                generatorTable
                    .toolbar {
                        selectionToolbar
                        ToolbarItem {
                            Spacer()
                        }
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
        .onChange(of: sortOrder) { sortOrder in
            sniglets.sort(using: sortOrder)
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
            TableColumn("table.sniglet".fromMacLocale(), value: \.word) { (row: SResult) in
                Text(row.word)
                    .contextMenu {
                        if selection != nil {
                            contextMenu
                        }
                    }
            }
            .width(min: 75, ideal: 125)
            TableColumn("table.score".fromMacLocale(), value: \.confidence) { (row: SResult) in
                Text("\(row.confidence.asPercentage())%")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .contextMenu {
                        if selection != nil {
                            contextMenu
                        }
                    }
            }
            .width(min: 75, ideal: 100, max: 125)
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
            ToolbarItem {
                Button {
                    requestedShare.toggle()
                } label: {
                    Label("generator.actions.share".fromMacLocale(), systemImage: "square.and.arrow.up")
                }
                .help("generator.help.share".fromMacLocale())
                .background(
                    SharingServicePicker(isPresented: $requestedShare, items: [getSelection()?.shareableText()])
                )
            }
        }
    }

    private func updateList() async {
        sniglets = await Sniglet.shared.getNewWords(count: generateSize).asArray()
    }

    private func copySelection() {
        getSelection()?.word.copyToClipboard()
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
