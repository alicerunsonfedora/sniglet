//
//  Generator.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

/// The view that represents the generator page. This is the main page that the user will interact with.
struct Generator: View {

    /// The number of sniglets to generate at a given time.
    @AppStorage("generateSize") var generateSize: Int = 1

    /// Whether to show the details page that explains the algorithm and confidence scores.
    @State var showDetails: Bool = false

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    /// The primary body for the view.
    var body: some View {
        Group {
            if generateSize == 1 {
                NavigationView {
                    GeneratorSingleView()
                }.navigationViewStyle(.stack)
            } else if horizontalSizeClass == .regular, #available(iOS 16.0, *) {
                NavigationStack {
                    GeneratorTable()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("generator.title")
                }
            } else {
                GeneratorList()
            }
        }
    }
}

/// A view that represents the sniglet that is generated with the appropriate styles applied.
struct GeneratorResultText: View {

    /// The text that will be rendered with custom styles.
    var word: String

    /// The primary body for the view.
    var body: some View {
        Text(word)
            .font(.system(.largeTitle, design: .serif))
            .bold()
            .textSelection(.enabled)
    }
}

/// A view that represents the generator confidence bar with a custom gradient applied.
struct GeneratorConfidenceBar: View {

    /// A double that the progress bar will represent.
    var confidence: Double

    /// The primary body for the view.
    var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.secondary)
                    .opacity(0.1)
                    .frame(width: geom.size.width, height: geom.size.height)
                LinearGradient(
                    colors: [.purple, .indigo, .blue, .cyan, .teal],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .mask(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.accentColor)
                            .frame(width: geom.size.width * confidence, height: geom.size.height)
                    }
            }
            .cornerRadius(geom.size.height / 2)
        }
        .frame(minHeight: 2, idealHeight: 8)
    }
}

/// A view that represents the confidence component which shows the confidence bar and a button to show the explanation dialog.
struct GeneratorConfidence: View {

    /// A double that the confidence bar will display.
    var confidence: Double

    /// An action that executes when the user clicks on "What's this?"
    /// Ideally, this should display the explanation dialog.
    var onDismissExplanation: () -> Void

    /// The primary body for the view.
    var body: some View {
        VStack {
            GeneratorConfidenceBar(confidence: confidence)
                .frame(height: 6)
                .padding(.horizontal)
                .padding(.bottom, 2)
            HStack {
                Text("**Confidence**: `\(confidence.asPercentage())`%")
                    .foregroundColor(.secondary)
                    .font(.system(.body, design: .rounded))
                Spacer()
                Button(action: { onDismissExplanation() }) {
                    Label("generator.button.help", systemImage: "questionmark.circle")
                        .font(.system(.body, design: .rounded))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct GeneratorConfidenceBar_Previews: View {
    var body: some View {
        NavigationView() {
            VStack(spacing: 32) {
                HStack {
                    Text("30%")
                    GeneratorConfidenceBar(confidence: 0.3)
                        .frame(height: 8)
                }
                .padding()
                HStack {
                    Text("49%")
                    GeneratorConfidenceBar(confidence: 0.49)
                        .frame(height: 8)

                }
                .padding()
                HStack {
                    Text("75%")
                    GeneratorConfidenceBar(confidence: 0.75)
                        .frame(height: 8)

                }
                .padding()
                HStack {
                    Text("85%")
                    GeneratorConfidenceBar(confidence: 0.85)
                        .frame(height: 8)

                }
                .padding()
                HStack {
                    Text("100%")
                    GeneratorConfidenceBar(confidence: 1.0)
                        .frame(height: 8)

                }
                .padding()
                Spacer()
            }
            .navigationTitle("Confidence Bars")
        }
    }
}

struct Generator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    GeneratorResultText(word: "morphology")
                }
            }
            .previewDevice("iPhone 13")
            GeneratorConfidenceBar_Previews()
                .previewDevice("iPhone 13")
            NavigationView {
                VStack {
                    GeneratorConfidence(confidence: 0.6) { }
                }
                .padding()
            }
            .previewInterfaceOrientation(.landscapeRight)
            .previewDevice("iPhone 13")
            GeneratorExplanation { }
            .previewDevice("iPhone 13")
        }
    }
}
