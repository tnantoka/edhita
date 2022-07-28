//
//  EditorView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

import SwiftUI

struct EditorView: View {
    let item: FinderItem

    @State var content = ""

    var webView: WebView {
        WebView(url: item.url)
    }
    var body: some View {
        HStack(spacing: 0.0) {
            TextEditor(text: $content)
                .navigationTitle(item.url.lastPathComponent)
                .navigationBarTitleDisplayMode(.inline)
                .padding(.all, 8.0)
                .onAppear {
                    guard let content = try? String(contentsOf: item.url) else { return }
                    self.content = content
                }
                .onChange(of: content) { content in
                    item.save(content: content)
                    //webView.reload()
                }
                .onAppear() {
                    UITextView.appearance().backgroundColor = .clear
                }.onDisappear() {
                    UITextView.appearance().backgroundColor = nil
                }
            Color
                .black
                .opacity(0.12)
                .frame(width: 1.0)
            webView
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
