//
//  CustomizePageView.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 9/4/22.
//

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

    /// The validation model to use.
    /// This is used in the picker. To store into User Defaults, refer to `generateMethod`.
    @State private var genMethodEnum: ValidatorKind = .Classic

    @State private var popoverBatch = false
    @State private var popoverGenerate = false
    
    var body: some View {
        Form {
            Section {
                Picker("customize.form.boundary-min".fromMacLocale(), selection: $minGenerationValue) {
                    ForEach(3..<maxGenerationValue, id: \.self) { value in
                        Text(
                            String(format: "customize.form.boundary-lbl".fromMacLocale(), value)
                        )
                        .tag(value)
                    }
                }
                Picker("customize.form.boundary-max".fromMacLocale(), selection: $maxGenerationValue) {
                    ForEach(minGenerationValue+1..<9, id: \.self) { value in
                        Text(
                            String(format: "customize.form.boundary-lbl".fromMacLocale(), value)
                        )
                        .tag(value)
                    }
                }
            }

            Divider()
                .padding(.vertical)

            Section {
                Picker("customize.form.validate-model".fromMacLocale(), selection: $genMethodEnum) {
                    ForEach(ValidatorKind.allCases, id: \.self) { kind in
                        Text(kind.rawValue)
                            .tag(kind)
                    }
                }
                .disabled(true) // TODO: Enable this when ready.
                Text("features.unavailable".fromMacLocale())
                    .foregroundColor(.secondary)
            }

            Section {
                HStack(spacing: 2) {
                    Text("customize.form.words".fromMacLocale())
                    TextField("", value: $generateBatches, format: .number)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                    Stepper(value: $generateBatches, in: 1...Int.max) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
                HStack(spacing: 2) {
                    Text("customize.form.batch-size".fromMacLocale())
                    TextField("", value: $batchSize, format: .number)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                    Stepper(value: $batchSize, in: 5...Int.max, step: 5) {
                        EmptyView()
                    }
                    .labelsHidden()
                    Button {
                        popoverBatch.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                    .buttonStyle(.link)
                    .padding(.leading, 6)
                    .popover(isPresented: $popoverBatch) {
                        VStack {
                            Text("settings.algorithm.batch.explain")
                        }
                        .frame(maxWidth: 300, minHeight: 64)
                        .padding(8)
                    }
                    
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button {
                    minGenerationValue = 3
                    maxGenerationValue = 8
                } label: {
                    Text("customize.form.boundary-reset".fromMacLocale())
                }
                Button {
                    openURL(.init(string: "sniglets://syllables")!)
                } label: {
                    Text("customize.form.syllables".fromMacLocale())
                }
            }
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct CustomizePageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizePageView()
            .frame(width: 600, height: 400)
    }
}
