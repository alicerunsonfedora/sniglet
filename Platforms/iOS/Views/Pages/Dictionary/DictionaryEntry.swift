//
//  DictionaryEntry.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 25/1/22.
//

import SwiftUI
import CoreData
import AVFoundation
import Bunker

/// A view that represents a single entry from the database.
struct DictionaryEntryView: View, SnigletShareable {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    /// The method of shari ng to use when sharing a saved sniglet from the dictionary.
    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The saved sniglet entry.
    @ObservedObject var entry: SavedWord

    /// Whether to show the details window that explains the validation process and confidence score.
    @State private var showDetails: Bool = false

    /// Whether to show the share sheet.
    @State var showShareSheet: Bool = false

    /// The user-assigned definition of the sniglet.
    @State var definition: String = ""

    @State private var savedImage: UIImage? = nil

    @State private var transferrableContent: Either<Image, String>? = nil

    /// The primary body for the view.
    var body: some View {
        CustomizableToolbarView(id: "actions") {
            List {
                Section {
                    VStack(spacing: 8) {
                        GeneratorResultText(word: entry.word ?? "")
                            .listRowSeparator(.hidden, edges: .bottom)
                        GeneratorConfidence(confidence: entry.confidence) {
                            showDetails.toggle()
                        }
                    }
                }
                .listRowInsets(.init(top: 16, leading: 0, bottom: 16, trailing: 0))
                .listRowBackground(Color.secondary.opacity(0))

                Section("Definition") {
                    TextEditor(text: $definition)
                        .font(.system(.body, design: .serif))
                        .lineSpacing(1.5)
                        .frame(minHeight: 300)
                }
            }
            .navigationTitle("saved.detail.title")
            .navigationBarTitleDisplayMode(.inline)
        } toolbar: {
            actionToolbar
        }
        .onAppear {
            definition = entry.note ?? ""
            savedImage = makeImage(in: savedPreview)
            if #available(iOS 16.0, *) {
                Task {
                    transferrableContent = await getTransferableContent()
                }
            }
        }
        .onDisappear {
            savedImage = nil
        }
        .onChange(of: definition) { _ in
            entry.note = definition
            DBController.shared.save()
        }
        .sheet(isPresented: $showDetails) {
            NavigationView {
                GeneratorExplanation {
                    showDetails.toggle()
                }
            }
        }
    }

    private var savedPreview: SavedDefinitionImage {
        SavedDefinitionImage(entry: entry)
    }

    private var sharedButton: some View {
        Group {
            if #available(iOS 16.0, *) {
                if let shared = transferrableContent {
                    switch shared {
                    case .left(let image):
                        ShareLink(item: image, preview: .init("Generated Image", image: image))
                    case .right(let text):
                        ShareLink(item: text)
                    }
                }
            } else {
                Button {
                    showShareSheet.toggle()
                } label: {
                    Label("saved.button.share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }

    func getShareableContent() -> Either<UIImage, String> {
        if shareMethod == "image", let image = savedImage {
            return .left(image)
        }
        return .right(entry.shareableText())
    }

    @available(iOS 16.0, *)
    func getTransferableContent() async -> Either<Image, String> {
        if shareMethod == "image", let image = ImageRenderer(content: SavedDefinitionImage(entry: entry)).uiImage {
            return .left(Image(uiImage: image))
        }
        return .right(entry.shareableText())
    }

    private var actionToolbar: some CustomizableToolbarContent {
        Group {
            customizeToolbarItem(with: "copy") {
                Button {
                    if let word = entry.word {
                        UIPasteboard.general.string = word
                    }
                } label: {
                    Label("generator.copy.button", systemImage: "doc.on.doc")
                }
            }

            customizeToolbarItem(with: "speech") {
                Button {
                    if let word = entry.word {
                        word.speak()
                    }
                } label: {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }
            }

            customizeToolbarItem(with: "share", primary: true) {
                sharedButton
                    .popover(isPresented: $showShareSheet) {
                        SharedActivity(activities: createShareActivities(from: getShareableContent()))
                    }
            }
        }
    }
}

struct DictionaryEntry_Previews: PreviewProvider {
    static let previewCtx = DBController.preview

    static var previews: some View {
        Group {
            NavigationView {
                DictionaryEntryView(entry: previewCtx.singleEntry())
            }
            .previewDevice("iPhone 13")
        }

    }
}
