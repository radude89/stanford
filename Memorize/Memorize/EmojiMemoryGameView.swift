//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Radu Dan on 20.12.2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            
            Text("\(viewModel.themeName.capitalized)")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text("Score: \(viewModel.score)")
            
            Grid(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        viewModel.choose(card: card)
                    }
                    .padding(5)
            }
            .padding()
            .foregroundColor(.orange)
            
            Button(action: {
                viewModel.restartGame()
            }) {
                Text("New Game")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding()
                    .overlay(
                        Capsule()
                            .stroke(Color.primary, lineWidth: 2)
                    )
            }
            .padding(.bottom)
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90), clockwise: true)
                    .padding(5)
                    .opacity(0.4)
                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // MARK: - Drawing Constants
    
    private let fontScaleFactor: CGFloat = 0.65
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}
