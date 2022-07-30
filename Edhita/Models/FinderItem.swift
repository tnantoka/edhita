//
//  FinderItem.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/25.
//

import Foundation

struct FinderItem: Identifiable, Hashable {
    let id: UUID
    var url: URL

    var isDirectory: Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }

    var contentModificationDate: Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date.distantPast
    }

    init(id: UUID = UUID(), url: URL) {
        self.id = id
        self.url = url
    }
    
    func save(content: String) {
        try? content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    func destroy() {
        try? FileManager.default.removeItem(at: url)
    }
}
