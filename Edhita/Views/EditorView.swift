//
//  EditorView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

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
    
    var webView: WebView {
        WebView(url: item.url)
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            if (mode == .edit || mode == .split) {
                TextEditor(text: $content)
                    .padding(.all, 8.0)
                    .onChange(of: content) { content in
                        item.save(content: content)
                    }
            }
            if (mode == .split) {
                Color
                    .black
                    .opacity(0.12)
                    .frame(width: 1.0)
            }
            if (mode == .preview || mode == .split) {
                webView
            }
        }
        .navigationTitle(item.url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let content = try? String(contentsOf: item.url) else { return }
            self.content = content
        }
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
        .toolbar {
            Picker("", selection: $mode) {
                ForEach(Mode.allCases) {
                    mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "root_file", withExtension: "txt", subdirectory: "root")!
        let item = FinderItem(url: url)
        NavigationView {
            EditorView(item: item)
        }
    }
}
