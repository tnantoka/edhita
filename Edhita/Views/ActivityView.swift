//
//  ActivityView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/03.
//

import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> some UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(activityItems: [])
    }
}
