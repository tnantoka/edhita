//
//  PromptView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/31.
//

import SwiftUI

struct PromptView: View {
    let title: String
    let textLabel: String
    let canSave: (String) -> Bool
    let onSave: (String) -> Void

    @State var text: String

    @FocusState private var isFocused

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text(title)) {
                TextField(textLabel, text: $text)
                    .focused($isFocused)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(NSLocalizedString("Cancel", comment: "")) {
                    dismiss()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(NSLocalizedString("Save", comment: "")) {
                    onSave(text)
                    dismiss()
                }
                .disabled(canSave(text))
            }
        }
        .onAppear {
            // FIXME: https://stackoverflow.com/questions/68073919/swiftui-focusstate-how-to-give-it-initial-value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFocused = true
            }
        }
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PromptView(
                title: "Title",
                textLabel: "Text",
                canSave: { _ in true },
                onSave: { _ in },
                text: ""
            )
        }
    }
}
