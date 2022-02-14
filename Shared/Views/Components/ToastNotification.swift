//
//  ToastNotification.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import SwiftUI

struct ToastNotification: View {
    @State var title: LocalizedStringKey
    @State var subtitle: LocalizedStringKey?
    @State var systemImage: String
    

    init(_ title: LocalizedStringKey, systemImage: String, with subtitle: LocalizedStringKey? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
                    .bold()
                if let sb = subtitle {
                    Text(sb)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }

        }
        .padding(.vertical)
        .padding(.horizontal, 24)
        .background {
            Color.init(uiColor: .secondarySystemBackground)
                .clipShape(Capsule())
                .shadow(radius: 4)
        }
    }
}

struct ToastNotification_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToastNotification(
                "Saved",
                systemImage: "bookmark.fill",
                with: "Go to Dictionary to view it."
            )
            ToastNotification(
                "Saved",
                systemImage: "bookmark.fill",
                with: "Go to Dictionary to view it."
            )
                .preferredColorScheme(.dark)
        }
    }
}
