//
//  WidgetConfidenceBar.swift
//  Sniglet WidgetExtension
//
//  Created by Marquis Kurt on 12/12/21.
//

import SwiftUI

struct WidgetConfidenceBar: View {
    var condifence: Double

    var body: some View {
        GeometryReader { geom in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.white)
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
                            .frame(width: geom.size.width * condifence, height: geom.size.height)
                    }
            }
            .cornerRadius(geom.size.height / 2)
        }
        .frame(minHeight: 2)
    }
}
