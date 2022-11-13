//
//  Modifiers.swift
//  DogBreedOS
//
//  Created by Tornelius Broadwater, Jr on 11/10/22.
//

import SwiftUI

// MARK: - Stroke Style
struct StrokeStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.3 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        }
    }
}

// MARK: - View Extension
extension View {
    func strokeStyle(cornerRadius: CGFloat) -> some View {
        self.modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}
