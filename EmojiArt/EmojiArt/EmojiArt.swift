//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Radu Dan on 08.01.2021.
//

import Foundation

// MARK: - EmojiArt
struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis: [Emoji] = []
    
    private var uniqueEmojiID = 0
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init() { 
    }
    
    init?(json: Data?) {
        guard let json = json, let emojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json) else {
            return nil
        }
        
        self = emojiArt
    }
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiID += 1
        emojis.append(
            Emoji(id: uniqueEmojiID, text: text, x: x, y: y, size: size)
        )
    }
}

// MARK: - Emoji
extension EmojiArt {
    struct Emoji: Identifiable, Codable, Hashable {
        let id: Int
        let text: String
        var x: Int // offset from center
        var y: Int // offset from center
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.id = id
            self.size = size
        }
    }
}
