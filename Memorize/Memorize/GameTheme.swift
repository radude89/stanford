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
    let name = "Halloween"
    let emojis = ["👻", "🎃", "🕷", "☠️", "🧟‍♂️", "🕸"].shuffled()
}

struct FoodEmojiMemoryGameTheme: EmojiMemoryGameTheme {
    let name = "Food"
    let emojis = ["🍏", "🥨", "🥩", "🍢", "🍰", "🍪"].shuffled()
}

struct ChristmasEmojiGameTheme: EmojiMemoryGameTheme {
    let name = "Christmas"
    let emojis = ["🎄", "❄️", "⛄️", "🎅", "🌲", "🧑‍🎄"].shuffled()
}

enum EmojiGameThemeFactory {
    static func makeRandomTheme() -> EmojiMemoryGameTheme {
        let supportedThemes: [EmojiMemoryGameTheme] = [HalloweenEmojiMemoryGameTheme(), FoodEmojiMemoryGameTheme(), ChristmasEmojiGameTheme()]
        return supportedThemes[Int.random(in: 0..<supportedThemes.count)]
    }
    
    static func makeGameTheme(using theme: GameTheme) -> EmojiMemoryGameTheme {
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
