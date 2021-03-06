//
//  Spinning.swift
//  EmojiArt
//
//  Created by Radu Dan on 27.01.2021.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false)
            )
            .onAppear { isVisible = true }
    }
}

extension View {
    func spinning() -> some View {
        modifier(Spinning())
    }
}
