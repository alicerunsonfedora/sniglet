//
//  CustomizePageView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/4/22.
//

import CompactSlider
import SwiftUI

struct CustomizePageView: View {
    @Environment(\.openURL) var openURL

    /// The number of batches at a given time to ensure that at least one valid sniglet appears.
    @AppStorage("algoBatchSize") var batchSize: Int = 25

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateBatches: Int = 1

    /// The validation model to use.
    @AppStorage("generateMethod") var generateMethod: String = "Classic"

    /// The minimum number of characters needed to generate a sniglet input.
    @AppStorage("algoMinBound") var minGenerationValue: Int = 3

    /// The maximum number of characters needed to generate a sniglet input.
    @AppStorage("algoMaxBound") var maxGenerationValue: Int = 8

    /// The minimum number of characters needed to generate a sniglet input.
    @State private var minGenVal: Double = 3.0

    /// The maximum number of characters needed to generate a sniglet input.
    @State private var maxGenVal: Double = 8.0

    /// The validation model to use.
    /// This is used in the picker. To store into User Defaults, refer to `generateMethod`.
    @State private var genMethodEnum: ValidatorKind = .Classic

    @State private var popoverBatch = false
    @State private var popoverGenerate = false
    @State private var sheetSyllables = false

    var body: some View {
        Form {
            Section {
                HStack(spacing: 4) {
                    SettingsBoundarySlider()
                        .frame(maxWidth: .infinity)
                }
            }

            Divider()
                .padding(.vertical)

//            Section {
//                Picker("customize.form.validate-model".fromMacLocale(), selection: $genMethodEnum) {
//                    ForEach(ValidatorKind.allCases, id: \.self) { kind in
//                        Text(kind.rawValue)
//                            .tag(kind)
//                    }
//                }
//                .disabled(true) // TODO: Enable this when ready.
//                Text("features.unavailable".fromMacLocale())
//                    .foregroundColor(.secondary)
//            }

            Section {
                HStack(spacing: 2) {
                    Text("customize.form.words".fromMacLocale())
                    TextField("", value: $generateBatches, format: .number)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                    Stepper(value: $generateBatches, in: 1 ... Int.max) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
                HStack(spacing: 2) {
                    Text("customize.form.batch-size".fromMacLocale())
                    TextField("", value: $batchSize, format: .number)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                    Stepper(value: $batchSize, in: 5 ... Int.max, step: 5) {
                        EmptyView()
                    }
                    .labelsHidden()
                    HelpButton(isPresented: $popoverBatch) {
                        Text("settings.algorithm.batch.explain")
                    }
                    .padding(.leading, 6)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button {
                    minGenerationValue = 3
                    maxGenerationValue = 8
                    minGenVal = 3.0
                    maxGenVal = 8.0
                } label: {
                    Text("customize.form.boundary-reset".fromMacLocale())
                }
                Button {
                    sheetSyllables.toggle()
                } label: {
                    Text("customize.form.syllables".fromMacLocale())
                }
            }
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
        .sheet(isPresented: $sheetSyllables) {
            CustomizeSyllablesView()
                .frame(maxWidth: 500, minHeight: 400)
                .toolbar {
                    Button {
                        sheetSyllables.toggle()
                    } label: {
                        Text("other.done".fromMacLocale())
                    }
                }
        }
    }
}

struct CustomizePageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizePageView()
            .frame(width: 600, height: 400)
    }
}
