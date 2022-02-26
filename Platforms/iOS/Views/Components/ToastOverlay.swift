//
//  Overlay.swift
//  Give Me a Sniglet (iOS)
//
//  Created by Marquis Kurt on 6/2/22.
//

import Foundation
import SwiftUI

struct ToastOverlay<T: View>: ViewModifier {

    @Binding var isPresented: Bool
    let delay: Double
    let overlay: T

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    overlay
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                withAnimation(.easeInOut) {
                                    isPresented = false
                                }
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isPresented = false
                            }
                        }
                    Spacer()
                }
            }
        }
    }

}

extension View {
    func toast<T: View>(isPresented: Binding<Bool>, dismissAfter time: Double = 5.0, content: () -> T) -> some View {
        self.modifier(ToastOverlay(isPresented: isPresented, delay: time, overlay: content()))
    }
}
