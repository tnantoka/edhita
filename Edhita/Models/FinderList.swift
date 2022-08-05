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

    static func createExamples() {
        let root = FinderList(url: rootURL)
        if FileManager.default.fileExists(atPath: rootURL.appendingPathComponent("examples").path) {
            return
        }

        root.addItem(name: "examples", isDirectory: true)

        let examples = FinderList(url: rootURL.appendingPathComponent("examples"))
        examples.addItem(name: "index.html", isDirectory: false)
        examples.addItem(name: "index.md", isDirectory: false)
        examples.addItem(name: "style.css", isDirectory: false)
        examples.addItem(name: "script.js", isDirectory: false)
        examples.refresh()

        let items = examples.items
        items.first { $0.filename == "index.md" }?.update(
            content: """
                # Hello
                - list item 1
                - list item 2
                - list item 3
                """
        )
        items.first { $0.filename == "script.js" }?.update(
            content: """
                document.querySelector('button').addEventListener('click', () => {
                  document.querySelector('input').value = new Date();
                });
                """
        )
        items.first { $0.filename == "style.css" }?.update(
            content: """
                body {
                  background: #f9f9f9;
                }
                """
        )
        items.first { $0.filename == "index.html" }?.update(
            content: """
                <!doctype html>
                <html>
                  <head>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <title>Example</title>
                    <link href="style.css" rel="stylesheet">
                  </head>
                  <body>
                    <h1>Hello, world!</h1>
                    <p>
                      <button>Hello</button><br>
                      <input type="text">
                    </p>
                    <script src="script.js"></script>
                  </body>
                </html>
                """
        )
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

    func renameItem(item: FinderItem?, name: String) {
        guard let item = item else { return }

        item.rename(name: name)
        refresh()
    }

    func moveItem(item: FinderItem?, url: URL) {
        guard let item = item else { return }

        item.move(directory: url)
        refresh()
    }

    func addItem(name: String, isDirectory: Bool) {
        let url = self.url.appendingPathComponent(name)

        if isDirectory {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        } else {
            try? "".write(to: url, atomically: true, encoding: .utf8)
        }
        refresh()
    }

    func downloadItem(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        if let data = try? Data(contentsOf: url) {
            try? data.write(to: self.url.appendingPathComponent(url.lastPathComponent))
        }
        refresh()
    }
}
