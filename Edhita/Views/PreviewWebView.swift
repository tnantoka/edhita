//
//  PreviewWebView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/27.
//

import Ink
import SwiftUI
import WebKit

struct PreviewWebView: UIViewRepresentable {
    let url: URL
    let reloader: Bool

    func makeUIView(context: Context) -> WKWebView {
        WKWebView(frame: .zero)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if isMarkdown {
            if let markdown = try? String(contentsOf: url) {
                let parser = MarkdownParser()
                let html = parser.html(from: markdown)
                uiView.loadHTMLString(html, baseURL: url.deletingLastPathComponent())
            }
        } else {
            let req = URLRequest(url: url)
            uiView.load(req)
        }
    }

    private var isMarkdown: Bool {
        url.lastPathComponent.hasSuffix(".md") || url.lastPathComponent.hasSuffix(".markdown")
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWebView(
            url: URL(string: "https://example.com/")!,
            reloader: false
        )
    }
}
