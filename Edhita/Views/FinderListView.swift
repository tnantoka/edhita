//
//  FinderListView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

import SwiftUI

struct FinderListView: View {
    let url: URL

    @State var items = [FinderItem]()

    var body: some View {
        List {
            ForEach(items) { item in
                if item.isDirectory {
                    NavigationLink(
                        destination: FinderListView(url: item.url)
                    ) {
                        FinderItemView(item: item)
                    }
                    .isDetailLink(false)
                } else {
                    NavigationLink(
                        destination: EditorView(item: item)
                    ) {
                        FinderItemView(item: item)
                    }
                }
            }
            .onDelete { indices in
                items.remove(atOffsets: indices)
            }
        }
        .listStyle(.plain)
        .navigationTitle(url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
        }
        .onAppear {
            items = FinderList.items(for: url)
        }
    }
}

struct FinderListView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "root", withExtension: nil)!
        NavigationView {
            FinderListView(url: url)
        }
    }
}
