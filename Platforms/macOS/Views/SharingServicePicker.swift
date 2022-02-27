//
//  SharingServicePicker.swift
//  Give Me a Sniglet
//
//  Created by Marquis Kurt on 27/2/22.
//

import Foundation
import SwiftUI
import AppKit

// Original: https://stackoverflow.com/a/60955909/5354594

struct SharingServicePicker: NSViewRepresentable {
    @Binding var isPresented: Bool
    var items: [Any] = []

    func makeNSView(context: Context) -> some NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        if isPresented {
            let share = NSSharingServicePicker(items: items)
            share.delegate = context.coordinator

            DispatchQueue.main.async {
                share.show(relativeTo: .zero.offsetBy(dx: 0, dy: -12), of: nsView, preferredEdge: .maxX)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }
}

class Coordinator: NSObject, NSSharingServicePickerDelegate {
    let owner: SharingServicePicker

    init(owner: SharingServicePicker) {
        self.owner = owner
    }

    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
        sharingServicePicker.delegate = nil
        self.owner.isPresented = false
    }
}
