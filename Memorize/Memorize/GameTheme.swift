//
//  GameTheme.swift
//  Memorize
//
//  Created by Radu Dan on 24.12.2020.
//

import Foundation

enum GameTheme: CaseIterable {
    case halloween
    case food
    case christmas
}

protocol EmojiMemoryGameTheme {
    var name: String { get }
    var emojis: [String] { get }
}

struct HalloweenEmojiMemoryGameTheme: EmojiMemoryGameTheme {
    typealias CardContent = String
    
    let name = "Halloween"
    let emojis = ["👻", "🎃", "🕷", "☠️", "🧟‍♂️", "🕸"].shuffled()
}

struct FoodEmojiMemoryGameTheme: EmojiMemoryGameTheme {
    typealias CardContent = String
    
    let name = "Food"
    let emojis = ["🍏", "🥨", "🥩", "🍢", "🍰", "🍪"].shuffled()
}

struct ChristmasEmojiGameTheme: EmojiMemoryGameTheme {
    typealias CardContent = String
    
    let name = "Christmas"
    let emojis = ["🎄", "❄️", "⛄️", "🎅", "🇨🇽", "🧑‍🎄"].shuffled()
}

enum EmojiGameThemeFactory {
    static func makeEmojiCards(using theme: GameTheme) -> EmojiMemoryGameTheme {
        switch theme {
        case .halloween:
            return HalloweenEmojiMemoryGameTheme()
            
        case .food:
            return FoodEmojiMemoryGameTheme()
            
        case .christmas:
            return ChristmasEmojiGameTheme()
        }
    }
}
