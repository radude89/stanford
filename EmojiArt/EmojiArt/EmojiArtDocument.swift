//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Radu Dan on 08.01.2021.
//

import SwiftUI

final class EmojiArtDocument: ObservableObject {
    static let palette = "🥨🚀📌🍪🍸☕️"
    
    @Published private var emojiArt = EmojiArt()
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intents
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        guard let index = emojiArt.emojis.firstIndex(matching: emoji) else {
            return
        }
        
        emojiArt.emojis[index].x += Int(offset.width)
        emojiArt.emojis[index].y += Int(offset.height)
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        guard let index = emojiArt.emojis.firstIndex(matching: emoji) else {
            return
        }
        
        emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    // MARK: - Private Methods
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        guard let url = emojiArt.backgroundURL else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            guard let imageData = try? Data(contentsOf: url) else {
                assertionFailure("Failed to fetch data from URL \(url.absoluteString)")
                return
            }
            
            DispatchQueue.main.async {
                if url == emojiArt.backgroundURL {
                    backgroundImage = UIImage(data: imageData)
                }
            }
        }
    }
    
}

// MARK: - Emoji Extensions
extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
