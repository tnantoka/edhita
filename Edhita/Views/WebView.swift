//
//  WebView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/27.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    let view = WKWebView(frame: .zero)

    func makeUIView(context: Context) -> WKWebView  {
        view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let req = URLRequest(url: url)
        uiView.load(req)
    }

    func reload() {
        view.reload()
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(
            url: URL(string: "https://example.com/")!
        )
    }
}

