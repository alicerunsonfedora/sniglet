//
//  SettingsGeneral.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI

struct SettingsGeneralView: View {
    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateBatches: Int = 1

    /// The method of sharing to use when sharing a saved sniglet from the dictionary.
    @AppStorage("shareMethod") var shareMethod: String = "image"

    @State private var sharedMethodEnum: ShareMethod = .image

    enum ShareMethod: String, CaseIterable {
        case image
        case text
    }

    var body: some View {
        Group {
            Section {
                Picker(selection: $sharedMethodEnum) {
                    Text("settings.saved.share_as.image")
                        .tag(ShareMethod.image)
                    Text("settings.saved.share_as.text")
                        .tag(ShareMethod.text)
                } label: {
                    Label("settings.saved.share_as.title", systemImage: "square.and.arrow.up")
                }
            }

            Section {
                Stepper(value: $generateBatches, in: 1...500) {
                    Label("Generate \(generateBatches) words", systemImage: "sparkles.rectangle.stack.fill")
                }
            } footer: {
                if generateBatches > 7 {
                    Label {
                        Text("frugal.warning.increased_values")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle")
                            .imageScale(.large)
                            .foregroundColor(.yellow)
                    }
                } else {
                    Text("")
                }
            }
        }
        .onAppear {
            sharedMethodEnum = ShareMethod(rawValue: shareMethod) ?? .image
        }
        .onChange(of: sharedMethodEnum) { value in
            shareMethod = value.rawValue
        }
    }
}

struct SettingsGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    SettingsGeneralView()
                }
                .navigationTitle("settings.general.title")
            }
                .previewDevice("iPhone 13")
        }
    }
}
