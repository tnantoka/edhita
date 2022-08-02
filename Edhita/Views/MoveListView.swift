//
//  MoveListView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/31.
//

import SwiftUI

struct MoveListView: View {
    @ObservedObject var list: FinderList

    @Binding var isPresented: Bool

    let item: FinderItem
    let onMove: (URL) -> Void

    var body: some View {
        List {
            ForEach(list.items) { item in
                if item.isDirectory {
                    NavigationLink(
                        destination: MoveListView(
                            list: FinderList(url: item.url), isPresented: $isPresented,
                            item: self.item, onMove: onMove)
                    ) {
                        FinderItemView(item: item)
                    }
                    .isDetailLink(false)
                } else {
                    FinderItemView(item: item)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(list.url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented.toggle()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Move") {
                    onMove(list.url)
                    isPresented.toggle()
                }
                .disabled(
                    item.url.deletingLastPathComponent() == list.url
                        || list.items.first(where: { $0.filename == item.filename }) != nil
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text(list.relativePath)
            }
        }
    }
}

struct MoveListView_Previews: PreviewProvider {
    static var previews: some View {
        let listURL = Bundle.main.url(forResource: "root", withExtension: nil)!
        let list = FinderList(url: listURL)
        let itemURL = Bundle.main.url(
            forResource: "root_file", withExtension: "txt", subdirectory: "root")!
        let item = FinderItem(url: itemURL)
        NavigationView {
            MoveListView(list: list, isPresented: .constant(true), item: item, onMove: { _ in })
        }
    }
}
