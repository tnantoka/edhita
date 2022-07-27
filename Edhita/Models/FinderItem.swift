//
//  FinderItem.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/25.
//

import Foundation

struct FinderItem: Identifiable {
    let id: UUID
    var url: URL

    var isDirectory: Bool {
        try! url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory!
    }

    var contentModificationDate: Date {
        try! url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!
    }

    init(id: UUID = UUID(), url: URL) {
        self.id = id
        self.url = url
    }
    
    func save(content: String) {
        try? content.write(to: url, atomically: true, encoding: .utf8)
    }
}
