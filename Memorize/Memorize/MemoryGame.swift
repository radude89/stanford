//
//  MemoryGame.swift
//  Memorize
//
//  Created by Radu Dan on 21.12.2020.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
    }
    
    private(set) var cards: [Card]
    private(set) var score = 0
    
    private var indexOfTheOneAndOnlyOneFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    mutating func choose(card: Card) {
        guard let chosenIndex = cards.firstIndex(matching: card),
              cards[chosenIndex].isFaceUp == false,
              cards[chosenIndex].isMatched == false else {
            return
        }
        
        if let potentialMatchIndex = indexOfTheOneAndOnlyOneFaceUpCard {
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                score += 2
            } else {
                score -= 1
            }
            cards[chosenIndex].isFaceUp = true
        } else {
            indexOfTheOneAndOnlyOneFaceUpCard = chosenIndex
        }
    }
}
