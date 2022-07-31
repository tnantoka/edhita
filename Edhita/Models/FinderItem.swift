//
//  FinderItem.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/25.
//

import Foundation

struct FinderItem: Identifiable, Hashable {
    var url: URL

    var id: String {
        url.path
    }

    var filename: String {
        url.lastPathComponent
    }

    var content: String {
        (try? String(contentsOf: url)) ?? ""
    }

    var isDirectory: Bool {
        (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
    }

    var contentModificationDate: Date {
        (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate)
            ?? Date.distantPast
    }

    init(url: URL) {
        self.url = url
    }

    func save(content: String) {
        try? content.write(to: url, atomically: true, encoding: .utf8)
    }

    func destroy() {
        try? FileManager.default.removeItem(at: url)
    }

    func duplicate() {
        var duplicatedURL = self.duplicatedURL(suffix: "")
        var i = 2
        while FileManager.default.fileExists(atPath: duplicatedURL.path) {
            duplicatedURL = self.duplicatedURL(suffix: " \(i)")
            i += 1
        }
        try? FileManager.default.copyItem(at: url, to: duplicatedURL)
    }

    private func duplicatedURL(suffix: String) -> URL {
        url.deletingLastPathComponent().appendingPathComponent(
            String(format: NSLocalizedString("Copy of %@", comment: ""), filename) + suffix)
    }

    func rename(name: String) {
        try? FileManager.default.moveItem(
            at: url, to: url.deletingLastPathComponent().appendingPathComponent(name))
    }
}
