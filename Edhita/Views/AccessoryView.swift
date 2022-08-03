//
//  AccessoryView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/03.
//

import SwiftUI

struct AccessoryView: View {
    let textView: UITextView

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Button(
                    action: {
                        textView.selectedRange = NSRange(
                            location: textView.selectedRange.location - 1,
                            length: textView.selectedRange.length)
                    },
                    label: {
                        Image(systemName: "arrow.left")
                    }
                )
                Button(
                    action: {
                        textView.selectedRange = NSRange(
                            location: textView.selectedRange.location + 1,
                            length: textView.selectedRange.length)
                    },
                    label: {
                        Image(systemName: "arrow.right")
                    }
                )
                Button(
                    action: {
                        textView.undoManager?.undo()
                    },
                    label: {
                        Image(systemName: "arrow.uturn.backward")
                    }
                )
                Button(
                    action: {
                        textView.undoManager?.redo()
                    },
                    label: {
                        Image(systemName: "arrow.uturn.forward")
                    }
                )
                ForEach(Array("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"), id: \.self) { char in
                    let text = String(char)
                    Button("  \(text)  ") {
                        textView.insertText(text)
                    }
                }
            }
        }
    }
}

struct AccessoryView_Previews: PreviewProvider {
    static var previews: some View {
        AccessoryView(textView: UITextView())
    }
}
