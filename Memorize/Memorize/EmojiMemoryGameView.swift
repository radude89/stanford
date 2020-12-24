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
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else if card.isMatched == false {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.orange)
                
            }
        }
        .font(.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let fontScaleFactor: CGFloat = 0.75
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(.dark)
    }
}
