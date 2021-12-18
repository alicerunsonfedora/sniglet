//
//  Generator.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 16/11/21.
//

import SwiftUI

struct Generator: View {
    @AppStorage("generateSize") var generateSize: Int = 1
    @State var showDetails: Bool = false

    var body: some View {
        Group {
            if generateSize == 1 {
                GeneratorSingleView()
            } else {
                GeneratorList()
            }
        }
    }
}

struct GeneratorResultText: View {
    var word: String

    var body: some View {
        Text(word)
            .font(.system(.largeTitle, design: .serif))
            .bold()
            .textSelection(.enabled)
    }
}

struct GeneratorConfidenceBar: View {
    var confidence: Double

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

struct GeneratorConfidence: View {
    var confidence: Double
    var onDismissExplanation: () -> Void

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

struct GeneratorExplanation: View {
    var onDismiss: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 48) {
                    Text("generator.explain.detail")
                        .padding(.horizontal)
                    HStack(spacing: 8) {
                        Spacer()
                        letterNode("a")
                        letterNode("b")
                        letterNode("c")
                        letterNode("d")
                        letterNode("e")
                        ForEach(0..<3) { _ in
                            letterNode("*")
                        }
                        Spacer()
                    }
                    Text("generator.explain.detail2")
                        .padding(.horizontal)
                    Text("generator.explain.detail3")
                        .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle("generator.explain.title")
            .toolbar {
                Button(action: onDismiss) {
                    Text("Dismiss")
                }
            }
        }
    }

    func letterNode(_ text: LocalizedStringKey) -> some View {
        Text(text)
            .font(.system(.title, design: .monospaced))
            .foregroundColor(.green)
            .frame(width: 36, height: 36)
            .background(Color.black)
            .cornerRadius(4)
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
