//
//  AppDelegate.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/04.
//

import Foundation
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        #if DEBUG
            if Constants.enableAd {
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        #else
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        #endif

        return true
    }
}
