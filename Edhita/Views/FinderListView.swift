//
//  FinderListView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

import SwiftUI

struct FinderListView: View {
    let url: URL

    @Environment(\.editMode) var editMode
    
    @State private var items = [FinderItem]()
    @State private var selectedItem: FinderItem?
    @State private var isPresentedItemDialog = false

    var body: some View {
        List(selection: $selectedItem) {
            ForEach(items, id: \.self) { item in
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation {
                        editMode?.wrappedValue = editMode?.wrappedValue.isEditing ?? false ? EditMode.inactive : EditMode.active
                    }
                    selectedItem = nil
                }) {
                    Image(systemName: editMode?.wrappedValue.isEditing ?? false ? "xmark" : "pencil")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text(FinderList.relativePath(for: url))
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    isPresentedItemDialog = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .disabled(selectedItem == nil)
                .confirmationDialog(selectedItem?.url.lastPathComponent ?? "", isPresented: $isPresentedItemDialog) {
                    Button(NSLocalizedString("Rename", comment: "")) {
                        
                    }
                    Button(NSLocalizedString("Duplicate", comment: "")) {
                        
                    }
                    Button(NSLocalizedString("Move", comment: "")) {
                        
                    }
                    Button(NSLocalizedString("Delete", comment: ""), role: .destructive) {
                        guard let selectedItem = selectedItem else {
                            return
                        }

                        withAnimation {
                            if let index = items.firstIndex(of: selectedItem) {
                                items.remove(at: index)
                            }
                            selectedItem.destroy()
                        }
                    }
                }
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
