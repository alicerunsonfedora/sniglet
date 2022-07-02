//
//  SettingsBoundarySlider.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 2/7/22.
//

import SwiftUI
import CompactSlider

/// A view that shows the range slider for word boundaries.
struct SettingsBoundarySlider: View {
    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    /// The minimum number of characters needed to generate a sniglet input.
    @State private var minGenVal: Double = 3.0

    /// The maximum number of characters needed to generate a sniglet input.
    @State private var maxGenVal: Double = 8.0

    var body: some View {
        CompactSlider(from: $minGenVal, to: $maxGenVal, in: 3...8, step: 1) {
            Text("settings.algorithm.boundaries.prompt")
            Spacer()
            Text(
                String(
                    format: String(localized: "settings.algorithm.boundaries.chars", comment: "Min characters")
                    , minGenerationValue
                )
                + " - " +
                String(
                    format: String(localized: "settings.algorithm.boundaries.chars", comment: "Max characters")
                    , maxGenerationValue
                )
            )
        }
        .onAppear {
            minGenVal = Double(minGenerationValue)
            maxGenVal = Double(maxGenerationValue)
        }
        .onChange(of: minGenVal) { value in
            minGenVal = value
            minGenerationValue = Int(value)
        }
        .onChange(of: maxGenVal) { value in
            maxGenVal = value
            maxGenerationValue = Int(value)
        }
    }
}

struct SettingsBoundarySlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SettingsBoundarySlider()
        }
        .padding()
    }
}
