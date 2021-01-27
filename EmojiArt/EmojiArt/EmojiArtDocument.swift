//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Radu Dan on 08.01.2021.
//

import SwiftUI
import Combine

final class EmojiArtDocument: ObservableObject {
    static let palette = "🥨🚀📌🍪🍸☕️"
    
    private static let emojiDefaultsKey = "EmojiArtDocument.Untitled"
    
    @Published private var emojiArt: EmojiArt
    @Published private(set) var backgroundImage: UIImage?
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: Self.emojiDefaultsKey)) ?? .init()
        
        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey: Self.emojiDefaultsKey)
        }
        
        fetchBackgroundImageData()
    }
    
    var emojis: [EmojiArt.Emoji] {
        emojiArt.emojis
    }
    
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
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    // MARK: - Private Methods
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        guard let url = emojiArt.backgroundURL else {
            return
        }
        
        fetchImageCancellable?.cancel()
        
        fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, urlResponse in UIImage(data: data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .assign(to: \.backgroundImage, on: self)
    }
    
}

// MARK: - Emoji Extensions
extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
