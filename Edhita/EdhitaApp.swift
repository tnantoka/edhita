//
//  EdhitaApp.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/24.
//

import AppTrackingTransparency
import SwiftUI

@main
struct EdhitaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FinderListView(list: FinderList(url: FinderList.rootURL))
                PlaceholderView()
            }
            .onReceive(
                NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            ) { _ in
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
        }
    }
}
