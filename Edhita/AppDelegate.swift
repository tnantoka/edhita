//
//  AppDelegate.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/04.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if Settings.shared.firstLaunch {
            FinderList.createExamples()
            Settings.shared.firstLaunch = false
        }

        return true
    }
}
