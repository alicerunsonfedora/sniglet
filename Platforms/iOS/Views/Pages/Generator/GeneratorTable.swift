//
//  GeneratorTable.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 12/8/22.
//

import Bunker
import CoreData
import SwiftUI

private typealias SResult = Sniglet.Result

@available(iOS 16.0, *)
struct GeneratorTable: View, SnigletShareable {
    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateSize: Int = 10

    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The managed object context of the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    /// Whether to display the alert that indicates a user has saved a sniglet to their dictionary.
    @State private var showAddedAlert: Bool = false

    @State internal var showShareSheet = false

    @State private var sniglets: [SResult] = []
    @State private var selection: SResult.ID?
    @State private var sortOrder = [
        KeyPathComparator(\SResult.word),
        KeyPathComparator(\SResult.confidence),
    ]
    @State private var transferableContent: Either<Image, String>?

    var body: some View {
        Table(sniglets, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("table.sniglet", value: \.word) { (row: SResult) in
                Text(row.word)
            }
            .width(min: 75, ideal: 125)
            TableColumn("table.score", value: \.confidence) { (row: SResult) in
                Text("\(row.confidence.asPercentage())%")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .width(min: 75, ideal: 100, max: 125)
        }
        .contextMenu(forSelectionType: SResult.ID.self) { selection in
            Button(action: copySelection) {
                Label("generator.copy.button", systemImage: "doc.on.doc")
            }
            Button(action: speakSelection) {
                Label("sound.button.prompt", systemImage: "speaker.wave.3")
            }
            Button(action: saveSelection) {
                Label("saved.button.add", systemImage: "bookmark")
            }
        }
        .toast(isPresented: $showAddedAlert, dismissAfter: 3.0) {
            ToastNotification("saved.alert.title", systemImage: "bookmark.fill", with: "saved.alert.detail")
        }
        .refreshable {
            Task { await updateList() }
        }
        .toolbar(id: "actions") { actionsToolbar }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task { await updateList() }
                } label: {
                    Label("generator.button.prompt", systemImage: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            Task { await updateList() }
        }
        .onChange(of: selection) { newSelection in
            Task {
                await updateTransferableContent()
            }
        }
    }

    private func updateList() async {
        sniglets = await Sniglet.shared.getNewWords(count: generateSize).asArray()
        selection = nil
    }

    private func copySelection() {
        guard let sniglet = sniglets.first(where: { $0.id == selection }) else { return }
        UIPasteboard.general.string = sniglet.word
    }

    /// Save the entry to the database.
    func saveSelection() {
        guard let result = sniglets.first(where: { $0.id == selection }) else { return }

        let entry = SavedWord(context: managedObjectContext)
        entry.word = result.word
        entry.confidence = result.confidence
        entry.validity = result.validation
        entry.note = ""
        DBController.shared.save()

        withAnimation(.easeInOut) {
            showAddedAlert = true
        }
    }

    private func speakSelection() {
        guard let sniglet = sniglets.first(where: { $0.id == selection }) else { return }
        sniglet.word.speak()
    }

    private var actionsToolbar: some CustomizableToolbarContent {
        Group {
            customizeToolbarItem(with: "copy") {
                Button(action: copySelection) {
                    Label("generator.copy.button", systemImage: "doc.on.doc")
                }
                .disabled(selection == nil)
            }
            customizeToolbarItem(with: "speak") {
                Button(action: speakSelection) {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }
                .disabled(selection == nil)
            }

            customizeToolbarItem(with: "save") {
                Button(action: saveSelection) {
                    Label("saved.button.add", systemImage: "bookmark")
                }
                .disabled(selection == nil)
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

    private func updateTransferableContent() async {
        guard let sniglet = sniglets.first(where: { $0.id == selection }) else { return }
        transferableContent = await getTransferableContent(for: sniglet)
    }

    @available(iOS 16.0, *)
    private func getTransferableContent(for result: SResult) async -> Either<Image, String> {
        if shareMethod == "image", let image = await ImageRenderer(content: SharedSnigletImage(entry: result)).uiImage {
            return .left(Image(uiImage: image))
        }
        return .right(result.shareableText())
    }

    func getShareableContent() -> Either<UIImage, String> {
        guard let sniglet = sniglets.first(where: { $0.id == selection }) else { return .right("") }
        return .right(sniglet.shareableText())
    }
}
