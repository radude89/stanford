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
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let store = EmojiArtDocumentStore(directory: url)
        return store
    }
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser()
                .environmentObject(Self.makeStore())
        }
    }
}
