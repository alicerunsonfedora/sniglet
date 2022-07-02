//
//  SettingsGeneration.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI
import CompactSlider

struct SettingsGenerationView: View {

    var body: some View {
        Section {
            NavigationLink {
                List {
                    SettingsGenerationBoundarySliderSegment()
                    SettingsGenerationBatchSegment()

                    // TODO: Re-enable the settings page for the Generation Method once the models are ready.
                    // SettingsGenerationMethodSegment()
                }
                .navigationTitle("settings.algorithm.title")
                .navigationBarTitleDisplayMode(.inline)
            } label: {
                Label("settings.algorithm.title", systemImage: "waveform")
            }
            .tag(SettingsView.Page.algorithm)
            NavigationLink {
                SettingsSyllableView().navigationBarTitleDisplayMode(.inline)
            } label: {
                Label("settings.syllable.title", systemImage: "quote.closing")
            }
            .tag(SettingsView.Page.syllable)
        } header: {
            Text("Generation")
        }
    }
}

struct SettingsGenerationBatchSegment: View {
    /// The number of batches at a given time to ensure that at least one valid sniglet appears.
    @AppStorage("algoBatchSize") var batchSize: Int = 25

    var body: some View {
        Section {
            Stepper(value: $batchSize, in: 5...Int.max, step: 5) {
                Label("\(batchSize) words", systemImage: "square.stack")
            }
        } header: {
            Text("settings.algorithm.batch.title")
        } footer: {
            Text("settings.algorithm.batch.explain")
        }
    }
}

@available(*, deprecated, message: "Use SettingsBoundarySlider instead.")
struct SettingsGenerationBoundarySegment: View {
    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    var body: some View {
        Section {
            Stepper(value: $minGenerationValue, in: 3...maxGenerationValue) {
                Label("Min: \(minGenerationValue) letters", systemImage: "smallcircle.filled.circle")
            }
            Stepper(value: $maxGenerationValue, in: minGenerationValue...8) {
                Label("Max: \(maxGenerationValue) letters", systemImage: "circle.circle.fill")
            }
        } header: {
            Text("settings.algorithm.boundaries.title")
        } footer: {
            Text("settings.algorithm.boundaries.explain")
        }
    }
}

struct SettingsGenerationBoundarySliderSegment: View {
    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    /// The minimum number of characters needed to generate a sniglet input.
    @State private var minGenVal: Double = 3.0

    /// The maximum number of characters needed to generate a sniglet input.
    @State private var maxGenVal: Double = 8.0

    var body: some View {
        Section {
            SettingsBoundarySlider()
        } header: {
            Text("settings.algorithm.boundaries.title")
        } footer: {
            Text("settings.algorithm.boundaries.explain")
        }

    }
}

struct SettingsGenerationMethodSegment: View {
    /// The validation model to use.
    @AppStorage("generateMethod") var generateMethod: String = "Classic"

    /// The validation model to use.
    /// This is used in the picker. To store into User Defaults, refer to `generateMethod`.
    @State private var genMethodEnum: ValidatorKind = .Classic

    var body: some View {
        Section {
            Picker("settings.algorithm.model.picker", selection: $genMethodEnum) {
                ForEach(ValidatorKind.allCases, id: \.self) { kind in
                    Text(kind.rawValue)
                        .tag(kind)
                }

            }
            .disabled(true) // TODO: Enable this when ready.
        } header: {
            Text("settings.algorithm.model.title")
        } footer: {
            Text("settings.algorithm.model.explain")
        }
        .onAppear {
            genMethodEnum = ValidatorKind(rawValue: generateMethod) ?? .Classic
        }
        .onChange(of: genMethodEnum) { value in
            generateMethod = value.rawValue
        }
    }
}
