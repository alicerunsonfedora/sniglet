//
//  DictionaryEntry.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 25/1/22.
//

import SwiftUI
import CoreData
import AVFoundation

/// A view that represents a single entry from the database.
struct DictionaryEntryView: View, SnigletShareable {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    /// Whether the user has turned on Tap to Copy.
    @AppStorage("allowClipboard") var tapToCopy: Bool = true

    /// The method of shari ng to use when sharing a saved sniglet from the dictionary.
    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The saved sniglet entry.
    @ObservedObject var entry: SavedWord

    /// Whether to show the details window that explains the validation process and confidence score.
    @State private var showDetails: Bool = false

    /// Whether to show the share sheet.
    @State internal var showShareSheet: Bool = false

    /// The user-assigned definition of the sniglet.
    @State var definition: String = ""

    /// A user-created image of the saved sniglet.
    @State private var savedImage: UIImage? = nil

    /// The primary body for the view.
    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    if tapToCopy {
                        TapToCopyButton(word: entry.word ?? "")
                        Spacer()
                    } else {
                        GeneratorResultText(word: entry.word ?? "")
                            .listRowSeparator(.hidden, edges: .bottom)
                    }
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
        .toolbar {
            ToolbarItem {
                if !tapToCopy {
                    Button {
                        if let word = entry.word {
                            UIPasteboard.general.string = word
                        }
                    } label: {
                        Label("generator.copy.button", systemImage: "doc.on.doc")
                    }
                }
            }

            ToolbarItem {
                if horizontalSizeClass == .compact {
                    Menu {
                        Button {
                            if let word = entry.word {
                                word.speak()
                            }
                        } label: {
                            Label("sound.button.prompt", systemImage: "speaker.wave.3")
                        }
                        sharedButton
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    .popover(isPresented: $showShareSheet) {
                        SharedActivity(activities: createShareActivities(from: getShareableContent()))
                    }
                } else {
                    Button {
                        if let word = entry.word {
                            word.speak()
                        }
                    } label: {
                        Label("sound.button.prompt", systemImage: "speaker.wave.3")
                    }
                }
            }
            ToolbarItem {
                sharedButton
                    .popover(isPresented: $showShareSheet) {
                        SharedActivity(activities: createShareActivities(from: getShareableContent()))
                    }
            }
        }
        .onAppear {
            definition = entry.note ?? ""
            savedImage = makeImage(in: savedPreview)
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
        Button {
            #if targetEnvironment(macCatalyst)
            showCatalystShareSheet(from: .init(x: 200, y: 84), with: .popover)
            #else
            showShareSheet.toggle()
            #endif
        } label: {
            Label("saved.button.share", systemImage: "square.and.arrow.up")
        }
    }

    func getShareableContent() -> Either<UIImage, String> {
        Either(shareMethod == "image" ? savedImage : nil, or: entry.shareableText())
    }

    @available(*, deprecated, renamed: "getShareableContent")
    private func getSharedData() -> Any {
        if shareMethod == "image" {
            return savedImage as Any
        }
        return entry.shareableText()
    }

    /// Shows the share sheet for Mac Catalyst.
    ///
    /// Use this function to show the share sheet and anchor it to the share button (or close to the share button).
    /// - Important: This method will be deperecated in the future as future versions of the app will no longer
    /// use Mac Catalyst.
    @available(macOS, introduced: 12.0, deprecated: 13.0, message: "Future versions of this app will not use Catalyst.")
    private func showCatalystShareSheet(from offset: CGPoint, with presentStyle: UIModalPresentationStyle = .automatic) {
        // Create the activity view controller that will be displayed. This is the share sheet.
        let activityVC = UIActivityViewController(
            activityItems: createShareActivities(from: getShareableContent()),
            applicationActivities: nil
        )
        activityVC.modalPresentationStyle = presentStyle

        // Grab the first window scene available to display the share sheet. This is needed because there may be
        // multiple scenes, per iPadOS 15 SDK documentation.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {

            // Anchor the activity view controller's source view to around where the share sheet button is located.
            // Source: https://www.raywenderlich.com/5037284-catalyst-tutorial-running-ipad-apps-on-macos
            if let view = windowScene.keyWindow?.rootViewController?.view {
                activityVC.popoverPresentationController?.sourceView = view
                activityVC.popoverPresentationController?.sourceRect = CGRect(
                    x: view.bounds.width - offset.x,
                    y: offset.y,
                    width: 1,
                    height: 1
                )
            }

            // Present the activity view controller.
            windowScene.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
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
