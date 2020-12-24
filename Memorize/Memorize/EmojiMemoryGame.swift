//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Radu Dan on 21.12.2020.
//

import SwiftUI

final class EmojiMemoryGame: ObservableObject {
    // @Published - calls objectWillChange.send()
    @Published private var model: MemoryGame<String>
    private(set) var themeName: String
    
    init(theme: GameTheme = GameTheme.allCases.shuffled().first ?? .halloween) {
        let theme = EmojiGameThemeFactory.makeEmojiCards(using: theme)
        themeName = theme.name
        model = Self.makeMemoryGame(emojis: theme.emojis)
    }
    
    func restartGame(theme: GameTheme = GameTheme.allCases.shuffled().first ?? .halloween) {
        let theme = EmojiGameThemeFactory.makeEmojiCards(using: theme)
        themeName = theme.name
        model = Self.makeMemoryGame(emojis: theme.emojis)
    }
    
    static func makeMemoryGame(emojis: [String]) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: (2...5).randomElement() ?? emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
