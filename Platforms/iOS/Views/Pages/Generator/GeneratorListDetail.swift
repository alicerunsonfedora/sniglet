//
//  GeneratorListDetail.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 9/13/22.
//

import Foundation
import SwiftUI
import CoreData
import Bunker

/// A view that represents a detail that is provided when the user clicks on a sniglet.
struct GeneratorListDetail: View, SnigletShareable {

    /// The managed object context of the database.
    @Environment(\.managedObjectContext) var managedObjectContext

    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The current result that will be displayed in the detail.
    @State var result: Sniglet.Result

    /// Whether to show the explanation dialog.
    @State var showDetails: Bool = false

    /// Whether to display the alert that indicates a user has saved a sniglet to their dictionary.
    @State private var showAddedAlert: Bool = false

    @State internal var showShareSheet: Bool = false

    @State private var transferableContent: Either<Image, String>? = nil

    /// The primary body for the view.
    var body: some View {
        CustomizableToolbarView(id: "actions") {
            mainContent
        } toolbar: {
            actionsToolbar
        }
    }

    func getShareableContent() -> Either<UIImage, String> {
        .right(result.shareableText())
    }

    /// Save the entry to the database.
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

    private var mainContent: some View {
        VStack(spacing: 16) {
            Spacer()
            GeneratorResultText(word: result.word)
            Spacer()
            GeneratorConfidence(confidence: result.confidence) {
                showDetails.toggle()
            }
        }
        .padding()
        .toast(isPresented: $showAddedAlert, dismissAfter: 3.0) {
            ToastNotification("saved.alert.title", systemImage: "bookmark.fill", with: "saved.alert.detail")
        }
        .sheet(isPresented: $showDetails) {
            NavigationView {
                GeneratorExplanation {
                    showDetails.toggle()
                }
            }
        }
        .onAppear {
            if #available(iOS 16.0, *) {
                Task { transferableContent = await getTransferableContent() }
            }
        }
    }

    private var actionsToolbar: some CustomizableToolbarContent {
        Group {
            customizeToolbarItem(with: "copy") {
                Button(action: { UIPasteboard.general.string = result.word }) {
                    Label("generator.copy.button", systemImage: "doc.on.doc")
                }
            }
            customizeToolbarItem(with: "speak") {
                Button {
                    result.word.speak()
                } label: {
                    Label("sound.button.prompt", systemImage: "speaker.wave.3")
                }
            }

            customizeToolbarItem(with: "save") {
                Button(action: saveSniglet) {
                    Label("saved.button.add", systemImage: "bookmark")
                }
            }

            customizeToolbarItem(with: "share", primary: true) {
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


    @available(iOS 16.0, *)
    func getTransferableContent() async -> Either<Image, String> {
        if shareMethod == "image", let image = await ImageRenderer(content: SharedSnigletImage(entry: result)).uiImage {
            return .left(Image(uiImage: image))
        }
        return .right(result.shareableText())
    }
}
