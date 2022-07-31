//
//  FinderListView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/07/26.
//

import SwiftUI

struct FinderListView: View {
    @Environment(\.editMode) private var editMode

    @ObservedObject var list: FinderList

    @State private var selectedItem: FinderItem?
    @State private var isPresentedItemDialog = false
    @State private var isPresentedRenamePrompt = false
    @State private var isPresentedMoveList = false
    @State private var isEditing = false

    var body: some View {
        List(selection: $selectedItem) {
            ForEach(list.items, id: \.self) { item in
                if item.isDirectory {
                    NavigationLink(
                        destination: FinderListView(list: FinderList(url: item.url))
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
        }
        .listStyle(.plain)
        .navigationTitle(list.url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                        selectedItem = nil
                        isPresentedItemDialog = false
                    },
                    label: {
                        Image(
                            systemName: isEditing
                                ? "xmark" : "pencil")

                    }
                )
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if !isEditing {
                        Button(
                            action: {},
                            label: {
                                Image(systemName: "plus")
                            }
                        )
                    }
                    if isEditing {
                        Button(
                            action: {
                                isPresentedItemDialog = true
                            },
                            label: {
                                Image(systemName: "ellipsis")
                            }
                        )
                        .disabled(selectedItem == nil)
                        .confirmationDialog(
                            selectedItem?.url.lastPathComponent ?? "",
                            isPresented: $isPresentedItemDialog
                        ) {
                            Button(NSLocalizedString("Rename", comment: "")) {
                                isPresentedRenamePrompt = true
                            }
                            Button(NSLocalizedString("Duplicate", comment: "")) {
                                withAnimation {
                                    list.duplicateItem(item: selectedItem)
                                }
                            }
                            Button(NSLocalizedString("Move", comment: "")) {
                                isPresentedMoveList = true
                            }
                            Button(NSLocalizedString("Delete", comment: ""), role: .destructive) {
                                withAnimation {
                                    list.deleteItem(item: selectedItem)
                                }
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text(list.relativePath)
            }
        }
        .sheet(isPresented: $isPresentedRenamePrompt) {
            NavigationView {
                PromptView(
                    title: NSLocalizedString("Rename", comment: ""),
                    textLabel: NSLocalizedString("Name", comment: ""),
                    canSave: { name in
                        name.isEmpty || list.items.first(where: { $0.filename == name }) != nil
                    },
                    onSave: { name in
                        list.renameItem(item: selectedItem, name: name)
                    },
                    text: selectedItem?.filename ?? ""
                )
            }
        }
        .sheet(isPresented: $isPresentedMoveList) {
            if let selectedItem = selectedItem {
                NavigationView {
                    MoveListView(
                        list: FinderList(url: FinderList.rootURL),
                        isPresented: $isPresentedMoveList, item: selectedItem
                    ) { url in
                        self.selectedItem = nil
                        list.moveItem(item: selectedItem, url: url)
                    }
                }
            }
        }
        .onAppear {
            list.refresh()
        }
        .environment(\.editMode, .constant(isEditing ? .active : .inactive))
    }
}

struct FinderListView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "root", withExtension: nil)!
        let list = FinderList(url: url)
        NavigationView {
            FinderListView(list: list)
        }
    }
}
