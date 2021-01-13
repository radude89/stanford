//
//  AnimatableSystemFontModifier.swift
//  EmojiArt
//
//  Created by Radu Dan on 13.01.2021.
//

import SwiftUI

struct AnimatableSystemFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content.font(Font.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func font(animatableWithSize size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
