//
//  TapToCopyButton.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 20/2/22.
//

import SwiftUI

struct TapToCopyButton: View {

    var word: String
    @State private var showCopyToast: Bool = false

    var body: some View {
        VStack {
            Button {
                UIPasteboard.general.string = word
                withAnimation {
                    showCopyToast.toggle()
                }
            } label: {
                GeneratorResultText(word: word)
            }
            .buttonStyle(.plain)
            Text("generator.copy.prompt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .toast(isPresented: $showCopyToast) {
            ToastNotification("generator.copy.complete", systemImage: "doc.on.doc")
        }
    }
}

struct TapToCopyButton_Previews: PreviewProvider {
    static var previews: some View {
        TapToCopyButton(word: "hello")
    }
}
