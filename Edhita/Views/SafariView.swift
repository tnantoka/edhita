//
//  SafariView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/01.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>)
        -> SFSafariViewController
    {
        let controller = SFSafariViewController(url: url)

        controller.dismissButtonStyle = .close

        return controller
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://example.com/")!)
    }
}
