//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Radu Dan on 21.12.2020.
//

import SwiftUI

final class EmojiMemoryGame: ObservableObject {
    // @Published - calls objectWillChange.send()
    @Published private var model: MemoryGame<String> = makeMemoryGame()
    
    static func makeMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷", "🚀", "⛑"].shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: (2...5).randomElement() ?? emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
