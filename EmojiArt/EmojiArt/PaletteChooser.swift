//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Radu Dan on 27.01.2021.
//

import SwiftUI

// MARK: - PaletteChooser
struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper(
                onIncrement: {
                    chosenPalette = document.palette(after: chosenPalette)
                },
                onDecrement: {
                    chosenPalette = document.palette(before: chosenPalette)
                },
                label: { EmptyView() }
            )
            
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                    PaletteEditor(
                        chosenPalette: $chosenPalette,
                        isShowing: $showPaletteEditor
                    )
                    .environmentObject(document)
                    .frame(minWidth: 300, minHeight: 500)
                }
            
            Text(document.paletteNames[chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

// MARK: - PaletteEditor
struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @Binding var isShowing: Bool
    
    @State private var paletteName = ""
    @State private var emojisToAdd = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                
                HStack {
                    Spacer()
                    Button("Done") {
                        isShowing = false
                    }
                    .padding()
                }
            }
            
            Divider()
            
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    })
                }
                
                Section(header: Text("Remove Emoji".uppercased())) {
                    Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: fontSize))
                            .onTapGesture {
                                chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                            }
                    }
                    .frame(height: height)
                }
            }
        }
        .onAppear {
            paletteName = document.paletteNames[chosenPalette] ?? ""
        }
    }
    
    // MARK: - Drawing constants
    
    private var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
    }
    
    private let fontSize: CGFloat = 40
}

// MARK: - Previews
struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(
            document: EmojiArtDocument(),
            chosenPalette: .constant("")
        )
    }
}
