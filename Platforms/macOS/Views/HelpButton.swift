//
//  HelpButton.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 8/5/22.
//

import SwiftUI

struct HelpButton: View {
    @Binding var isPresented: Bool
    @State var onClick: (() -> Void)? = nil
    @State var help: () -> Text

    init(isPresented: Binding<Bool>, help: @escaping () -> Text) {
        self.help = help
        onClick = nil
        _isPresented = isPresented
    }

    init(onClick: @escaping () -> Void) {
        help = { Text("") }
        self.onClick = onClick
        _isPresented = .constant(false)
    }

    var body: some View {
        Button {
            if let handler = onClick {
                handler()
            } else {
                isPresented.toggle()
            }
        } label: {
            Image(systemName: "questionmark.circle")
        }
        .buttonStyle(.link)
        .popover(isPresented: $isPresented) {
            VStack {
                help()
            }
            .frame(maxWidth: 300, minHeight: 64)
            .padding(8)
        }
    }
}

struct HelpButton_Previews: PreviewProvider {
    @State static var isPresented: Bool = true
    static var previews: some View {
        HelpButton(isPresented: $isPresented) {
            Text("Hello!")
        }
    }
}
