//
//  FontSettingsView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/02.
//

import SwiftUI

struct FontSettingsView: View {
    @State var fontName = FontManager.defaultFontName
    @State var fontSize = FontManager.defaultFontSize
    @State var textColor = Color.black
    @State var backgroundColor = Color.white

    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                Picker("Font name", selection: $fontName) {
                    ForEach(FontManager.shared.fontNames, id: \.self) { name in
                        Text(name).font(FontManager.font(for: name))
                    }
                }
                Picker("Font size", selection: $fontSize) {
                    ForEach(FontManager.shared.fontSizes, id: \.self) { size in
                        Text("\(Int(size))").font(.system(size: fontSize))
                    }
                }
                ColorPicker("Text color", selection: $textColor)
                ColorPicker("Background color", selection: $backgroundColor)
            }
            Section(header: Text("Preview")) {
                Text("ABCDEFGHIJKLM NOPQRSTUVWXYZ abcdefghijklm nopqrstuvwxyz 1234567890")
                    .font(.custom(fontName, size: fontSize))
                    .foregroundColor(textColor)
                    .background(backgroundColor)
            }
        }
        .navigationTitle("Font")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reset") {
                    fontName = FontManager.defaultFontName
                    fontSize = FontManager.defaultFontSize
                    textColor = Color.black
                    backgroundColor = Color.white
                }
            }
        }
    }
}

struct FontSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FontSettingsView()
        }
    }
}
