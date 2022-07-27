//
//  EdhitaApp.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/24.
//

import SwiftUI

@main
struct EdhitaApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                FinderListView(url: FinderList.rootURL)
            }
        }
    }
}
