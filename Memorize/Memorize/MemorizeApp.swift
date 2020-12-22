//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Radu Dan on 20.12.2020.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
