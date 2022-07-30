//
//  FinderList.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/25.
//

import Foundation

class FinderList: ObservableObject {
    let url: URL
    @Published var items: [FinderItem] = []

    var relativePath: String {
        FinderList.relativePath(for: url)
    }

    init(url: URL) {
        self.url = url
        refresh()
    }

    func refresh() {
        items = FinderList.items(for: url)
    }
}

extension FinderList {
    static var rootURL: URL {
        guard
            let documentDirectory = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
        else { fatalError() }
        return documentDirectory
    }

    static func items(for url: URL) -> [FinderItem] {
        guard
            let urls = try? FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.contentModificationDateKey, .isDirectoryKey]
            )
        else { fatalError() }

        return urls.map { FinderItem(url: $0) }.sorted {
            $0.contentModificationDate > $1.contentModificationDate
        }
    }

    static func relativePath(for url: URL) -> String {
        let path = url.path.replacingOccurrences(of: rootURL.path, with: "")
        return path.isEmpty ? "/" : path
    }
}

extension FinderList {
    func deleteItem(item: FinderItem?) {
        guard let item = item else { return }

        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
        item.destroy()
    }

    func duplicateItem(item: FinderItem?) {
        guard let item = item else { return }

        item.duplicate()
        refresh()
    }
}
