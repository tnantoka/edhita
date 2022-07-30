//
//  WebView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/27.
//

import Ink
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    private let view = WKWebView(frame: .zero)

    func makeUIView(context: Context) -> WKWebView {
        view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if isMarkdown {
            if let markdown = try? String(contentsOf: url) {
                let parser = MarkdownParser()
                let html = parser.html(from: markdown)
                uiView.loadHTMLString(html, baseURL: url)
            }
        } else {
            let req = URLRequest(url: url)
            uiView.load(req)
        }
    }

    func reload() {
        view.reload()
    }

    private var isMarkdown: Bool {
        url.lastPathComponent.hasSuffix(".md") || url.lastPathComponent.hasSuffix(".markdown")
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(
            url: URL(string: "https://example.com/")!
        )
    }
}
