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
struct DictionaryEntryView: View {

    /// Whether the user has turned on Tap to Copy.
    @AppStorage("allowClipboard") var tapToCopy: Bool = true

    /// The method of sharing to use when sharing a saved sniglet from the dictionary.
    @AppStorage("shareMethod") var shareMethod: String = "image"

    /// The saved sniglet entry.
    @ObservedObject var entry: SavedWord

    /// Whether to show the details window that explains the validation process and confidence score.
    @State private var showDetails: Bool = false

    @State private var showShareSheet: Bool = false

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
            if !tapToCopy {
                Button {
                    if let word = entry.word {
                        UIPasteboard.general.string = word
                    }
                } label: {
                    Label("generator.copy.button", systemImage: "doc.on.doc")
                }
            }
            Button {
                if let word = entry.word {
                    word.speak()
                }
            } label: {
                Label("sound.button.prompt", systemImage: "speaker.wave.3")
            }
            sharedButton
        }
        .onAppear {
            definition = entry.note ?? ""
            savedImage = makeImage()
        }
        .onDisappear {
            savedImage = nil
        }
        .onChange(of: definition) { _ in
            entry.note = definition
            DBController.shared.save()
        }
        .sheet(isPresented: $showDetails) {
            GeneratorExplanation {
                showDetails.toggle()
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
        .popover(isPresented: $showShareSheet) {
            SharedActivity(activities: [ getSharedData() as Any ])
        }
    }

    private func getSharedData() -> Any {
        if shareMethod == "image" {
            return savedImage as Any
        }
        return """
        Check out this sniglet I generated:
        \(entry.word ?? "")
        \(entry.note ?? "")

        Confidence: \(entry.confidence.asPercentage())%
        From Give Me A Sniglet
        """
    }

    /// Generates an image used to share with others.
    /// - Returns: A UIImage containing the rendered view of the saved image.
    ///
    /// Original: https://codakuma.com/swiftui-view-to-image/
    private func makeImage() -> UIImage {
        let window = UIWindow(
            frame: CGRect(
                origin: .init(x: 0, y: -225),
                size: CGSize(width: 550, height: 275)
            )
        )

        let hosting = UIHostingController(rootView: savedPreview)
        hosting.view.frame = window.frame
        hosting.view.backgroundColor = .savedBackground

        window.backgroundColor = .savedBackground
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()

        return hosting.view.renderedImage
    }

    /// Shows the share sheet for Mac Catalyst.
    ///
    /// Use this function to show the share sheet and anchor it to the share button (or close to the share button).
    private func showCatalystShareSheet(from offset: CGPoint, with presentStyle: UIModalPresentationStyle = .automatic) {
        // Create the activity view controller that will be displayed. This is the share sheet.
        let activityVC = UIActivityViewController(
            activityItems: [getSharedData() as Any],
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
