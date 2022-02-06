//
//  SettingsGeneral.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI

struct SettingsGeneralView: View {
    
    /// Whether the user had turned on "Tap to Copy"
    @AppStorage("allowClipboard") var allowCopying: Bool = true

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateBatches: Int = 1

    var body: some View {
        Group {
            Section {
                Toggle(isOn: $allowCopying) {
                    Label("settings.clipboard.name", systemImage: "doc.on.clipboard")
                }
            } header: {
                Text("settings.general.title")
            } footer: {
                Text("settings.clipboard.footer")
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
    }
}
