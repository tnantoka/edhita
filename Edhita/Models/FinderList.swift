//
//  FinderList.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/25.
//

import Foundation

struct FinderList {
    static var rootURL: URL {
        guard let documentDirectory = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ) else { fatalError() }
        return documentDirectory
    }
    
    static func items(for url: URL) -> [FinderItem] {
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.contentModificationDateKey, .isDirectoryKey]
        ) else { fatalError() }

        return urls.map { FinderItem(url: $0) }
    }
}
