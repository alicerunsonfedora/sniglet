//
//  Settings.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

/// A view that represents the settings page.
struct SettingsView: View {

    /// The current page the user is viewing.
    @State private var currentPage: Page? = nil

    /// The validation model to use.
    /// This is used in the picker. To store into User Defaults, refer to `generateMethod`.
    @State private var genMethodEnum: ValidatorKind = .Classic

    /// The horizontal size class of the app: either compact or standard.
    /// This is used to determine whether the device is in landscape or if running on iPadOS and/or macOS.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// An enumeration for the different pages in the settings view.
    enum Page: String, Hashable {

        /// Stores the general settings.
        case general

        /// Stores the algorithm-specific settings.
        case algorithm

        /// Stores the syllable shapes settings.
        case syllable
    }

    /// The primary body for the view.
    var body: some View {
        NavigationView {
            if horizontalSizeClass == .compact {
                bodyPhone
            } else {
                bodyTablet
            }

            if currentPage == nil && horizontalSizeClass == .regular {
                List {
                    SettingsGeneralView()
                    SettingsAboutView()
                }
                .navigationTitle("settings.general.title")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.insetGrouped)
            }
        }
    }

    /// The view to use when in portrait mode or for iPhones.
    var bodyPhone: some View {
        List {
            SettingsGeneralView()
            SettingsGenerationView()

            NavigationLink {
                List { SettingsAboutView() }
                    .navigationTitle("settings.info.title")
            } label: {
                Label("settings.info.title", systemImage: "info.circle")
            }

        }
        .listStyle(.insetGrouped)
        .navigationTitle("settings.title")
    }

    /// The view to use when in landscape mode or for iPads/Macs.
    var bodyTablet: some View {
        List(selection: $currentPage) {
            NavigationLink(destination: {
                    List {
                        SettingsGeneralView()
                        SettingsAboutView()
                    }
                    .navigationTitle("settings.general.title")
                    .navigationBarTitleDisplayMode(.inline)
            }) {
                Label("settings.general.title", systemImage: "gear")
            }
            .tag(Page.general)
            SettingsGenerationView()
        }
        .navigationTitle("settings.title")
        .listStyle(.sidebar)
    }
}

// MARK: - Previews

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice("iPhone 13")
            NavigationView {
                List {
                    SettingsGenerationBoundarySliderSegment()
                    SettingsGenerationBatchSegment()
                    SettingsGenerationMethodSegment()
                }
                .navigationTitle("settings.algorithm.title")
            }
                .previewDevice("iPhone 13")
            NavigationView {
                SettingsSyllableView()
            }
                .previewDevice("iPhone 13")
            NavigationView {
                List {
                    SettingsAboutView()
                        .navigationTitle("settings.info.title")
                }
            }
                .previewDevice("iPhone 13")
            SettingsView()
                .previewInterfaceOrientation(.landscapeRight)
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
