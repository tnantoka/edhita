//
//  EdhitaApp.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/24.
//

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
        }
    }
}
