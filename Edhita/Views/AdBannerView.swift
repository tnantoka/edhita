//
//  AdBannerView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/04.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

struct AdBannerView: View {
    @State private var onReady = false

    var body: some View {
        #if DEBUG
            let height = Constants.enableAd ? [50, 100].randomElement() ?? 50 : 0
        #else
            let height = [50, 100].randomElement() ?? 50
        #endif

        if onReady {
            AdBannerViewWithController(height: height).frame(height: CGFloat(height))
        } else {
            VStack {}
                .onAppear {
                    AdManager.shared.start { onReady = true }
                }
        }
    }
}

struct AdBannerViewWithController: UIViewControllerRepresentable {
    let height: Int

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<AdBannerViewWithController>
    ) -> UIViewController {
        let controller = UIViewController()

        let view = BannerView(adSize: height == 50 ? AdSizeBanner : AdSizeLargeBanner)

        #if DEBUG
            view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
            view.adUnitID = Constants.adUnitID
        #endif

        view.rootViewController = controller
        #if DEBUG
            if Constants.enableAd {
                view.load(Request())
            }
        #else
            view.load(Request())
        #endif

        controller.view.addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "view": view
        ]
        let horizontal = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[view]-0-|",
            options: [],
            metrics: nil,
            views: views
        )
        NSLayoutConstraint.activate(horizontal)

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct AdBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdBannerView()
    }
}
