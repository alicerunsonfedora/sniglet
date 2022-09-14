//
//  GeneratorSingle.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 22/11/21.
//

import Foundation
import CoreData
import SwiftUI
import AVFoundation
import Bunker

/// A view that represents the single generation view.
struct GeneratorSingleView: View, SnigletShareable {
    @Environment(\.managedObjectContext) var managedObjectContext

    @AppStorage("allowClipboard") var tapToCopy: Bool = true
    @AppStorage("shareMethod") var shareMethod: String = "image"

    @State var result: Sniglet.Result = .empty()
    @State var showDetails: Bool = false
    @State var showShareSheet: Bool = false

    @State private var showAddedAlert: Bool = false
    @State private var stack = Set<Sniglet.Result>()
    @State private var transferableContent: Either<Image, String>? = nil

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            GeneratorResultText(word: result.word)
            Button {
                Task {
                    await setSniglet()
                }
            } label: {
                Label("generator.button.prompt", systemImage: "wand.and.stars")
            }

            .buttonStyle(.borderedProminent)
            #if os(iOS)
            .cornerRadius(16)
            #endif
            
            Spacer()

            GeneratorConfidence(confidence: result.confidence) {
                showDetails.toggle()
            }

        }
        .toast(isPresented: $showAddedAlert, dismissAfter: 3.0) {
            ToastNotification("saved.alert.title", systemImage: "bookmark.fill", with: "saved.alert.detail")
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Menu {
                    ForEach(Array(stack).reversed()) { sniglet in
                        Button {
                            result = sniglet
                        } label: {
                            Label(sniglet.word, systemImage: "clock.arrow.circlepath")
                        }

                    }
                } label: {
                    Image(systemName: "rectangle.stack")
                }
                .disabled(stack.isEmpty)
            }
        }
        .toolbar(id: "actions") {
            actionToolbar
        }
        .onAppear {
            Task {
                await setSniglet()
                if #available(iOS 16.0, *) {
                    transferableContent = await getTransferableContent()
                }
            }
        }
        .onChange(of: result) { newResult in
            result = newResult
        }
        .sheet(isPresented: $showDetails) {
            NavigationView {
                GeneratorExplanation {
                    showDetails.toggle()
                }
            }
        }
        .padding()
    }

    private var actionToolbar: some CustomizableToolbarContent {
        Group {
            ToolbarItem(id: "speech", placement: .primaryAction) {
                Button {
                    result.word.speak()
                } label: {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }
            }
            ToolbarItem(id: "save") {
                Button(action: saveSniglet) {
                    Label("saved.button.add", systemImage: "bookmark")
                }
            }
            ToolbarItem(id: "share") {
                    if #available(iOS 16.0, *), let shared = transferableContent {
                    Group {
                        switch shared {
                        case .left(let image):
                            ShareLink(item: image, preview: .init("Generated Image", image: image))
                        case .right(let text):
                            ShareLink(item: text, subject: Text("Generated Text"))
                        }
                    }
                } else {
                    Button {
                        showShareSheet.toggle()
                    } label: {
                        Label("saved.button.share", systemImage: "square.and.arrow.up")
                    }
                    .popover(isPresented: $showShareSheet) {
                        SharedActivity(activities: createShareActivities(from: getShareableContent()))
                    }
                }
            }
        }
    }

    private var sharedPreview: SharedSnigletImage {
        SharedSnigletImage(entry: result)
    }

    func getShareableContent() -> Either<UIImage, String> {
        .right(result.shareableText())
    }

    @available(iOS 16.0, *)
    func getTransferableContent() async -> Either<Image, String> {
        if shareMethod == "image", let image = await ImageRenderer(content: sharedPreview).uiImage {
            return .left(Image(uiImage: image))
        }
        return .right(result.shareableText())
    }

    /// Sets the result to a generated sniglet.
    func setSniglet() async {
        if stack.count >= 5 { stack.removeFirst() }
        if result != .empty() { stack.insert(result) }
        result = await Sniglet.shared.getNewWords().first ?? .null()
    }

    /// Saves the sniglet to the user's dictionary.
    func saveSniglet() {
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
}

struct GeneratorSingle_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            GeneratorSingleView()
                .previewDevice("iPhone 13")
        }
    }
}
