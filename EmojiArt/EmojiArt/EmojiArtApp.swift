//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Radu Dan on 08.01.2021.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    private static func makeStore() -> EmojiArtDocumentStore {
        let store = EmojiArtDocumentStore(named: "Emoji Art")
        return store
    }
    
    var body: some Scene {
        WindowGroup {
//            EmojiArtDocumentView(document: EmojiArtDocument())
            EmojiArtDocumentChooser()
                .environmentObject(Self.makeStore())
        }
    }
}
