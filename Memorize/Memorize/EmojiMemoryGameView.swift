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
                        withAnimation(.linear(duration: 0.75)) {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
            }
            .padding()
            .foregroundColor(.orange)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.restartGame()
                }
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
    
    @State private var animatedBonusRemaining = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: .degrees(0-90),
                            endAngle: .degrees((-animatedBonusRemaining * 360) - 90),
                            clockwise: true
                        )
                        .onAppear(perform: startBonusTimeAnimation)
                    } else {
                        Pie(
                            startAngle: .degrees(0-90),
                            endAngle: .degrees((-card.bonusRemaining * 360) - 90),
                            clockwise: true
                        )
                    }
                }
                .padding(5)
                .opacity(0.4)
                .transition(.identity)
                
                Text(card.content)
                    .font(.system(size: fontSize(for: size)))
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(
                        card.isMatched ?
                            Animation.linear(duration: 1).repeatForever(autoreverses: false) :
                            .default
                    )
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.scale)
        }
    }
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
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
