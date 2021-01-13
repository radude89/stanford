//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Radu Dan on 13.01.2021.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        if uiImage != nil {
            Image(uiImage: uiImage!)
        }
    }
}

struct OptionalImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage()
    }
}
