//
//  EditorView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

import Introspect
import SwiftUI

struct EditorView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case edit = "Edit"
        case preview = "Preview"
        case split = "Split"

        var id: String { rawValue }
    }

    let item: FinderItem

    @State private var content = ""
    @State private var mode = Mode.edit
    @State private var reloader = false
    @State private var isPresentedActivity = false
    @State private var textView: UITextView?

    var webView: PreviewWebView {
        PreviewWebView(url: item.url, reloader: reloader)
    }

    var body: some View {
        HStack(spacing: 0.0) {
            if mode == .edit || mode == .split {
                TextEditor(text: $content)
                    .padding(.all, 8.0)
                    .onChange(of: content) { content in
                        item.update(content: content)
                        reloader.toggle()
                    }
                    .background(Settings.shared.backgroundColor)
                    .foregroundColor(Settings.shared.textColor)
                    .font(.custom(Settings.shared.fontName, size: Settings.shared.fontSize))
                    .disabled(!item.isEditable)
                    .introspectTextView(customize: { textView in
                        self.textView = textView
                    })
            }
            if mode == .split {
                Color
                    .black
                    .opacity(0.12)
                    .frame(width: 1.0)
            }
            if mode == .preview || mode == .split {
                webView
            }
        }
        .navigationTitle(item.url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.content =
                item.isEditable
                ? item.content : NSLocalizedString("The item cannot be edited", comment: "")
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Picker("", selection: $mode) {
                    ForEach(Mode.allCases) {
                        mode in
                        Text(NSLocalizedString(mode.rawValue, comment: "")).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(
                        action: {
                            isPresentedActivity.toggle()
                        },
                        label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    )
                    Button(
                        action: {
                            reloader.toggle()
                        },
                        label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    )
                    .disabled(mode == .edit)
                    Spacer()
                    Text(String(format: NSLocalizedString("Chars: %d", comment: ""), content.count))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                if let textView = textView, Settings.shared.keyboardAccessory {
                    AccessoryView(textView: textView)
                }

            }
        }
        .sheet(isPresented: $isPresentedActivity) {
            ActivityView(activityItems: item.activityItems)
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(
            forResource: "root_file", withExtension: "txt", subdirectory: "root")!
        let item = FinderItem(url: url)
        NavigationView {
            EditorView(item: item)
        }
    }
}
