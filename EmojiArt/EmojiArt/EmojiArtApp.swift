//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Radu Dan on 08.01.2021.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
