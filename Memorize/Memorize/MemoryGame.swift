//
//  MemoryGame.swift
//  Memorize
//
//  Created by Radu Dan on 21.12.2020.
//

import Foundation

struct MemoryGame<CardContent> {
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = true
        var isMatched = false
        var content: CardContent
    }
    
    var cards: [Card]
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    mutating func choose(card: Card) {
        print("Card chosen: \(card)")
        let chosenIndex = index(of: card)
        cards[chosenIndex].isFaceUp.toggle()
    }
    
    private func index(of card: Card) -> Int {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
        
        return 0
    }
}
