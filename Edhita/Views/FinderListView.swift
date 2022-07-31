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
                            editMode?.wrappedValue =
                                editMode?.wrappedValue.isEditing ?? false
                                ? EditMode.inactive : EditMode.active
                        }
                        selectedItem = nil
                        isPresentedItemDialog = false
                    },
                    label: {
                        Image(
                            systemName: editMode?.wrappedValue.isEditing ?? false
                                ? "xmark" : "pencil")

                    }
                )
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if !(editMode?.wrappedValue.isEditing ?? false) {
                        Button(
                            action: {},
                            label: {
                                Image(systemName: "plus")
                            }
                        )
                    }
                    if editMode?.wrappedValue.isEditing ?? false {
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
            ToolbarItem(placement: .bottomBar) {
            }
        }
        .sheet(isPresented: $isPresentedRenamePrompt) {
            NavigationView {
                PromptView(
                    title: NSLocalizedString("Rename", comment: ""),
                    textLabel: NSLocalizedString("Name", comment: ""),
                    defaultText: selectedItem?.filename ?? "",
                    canSave: { name in
                        name.isEmpty || list.items.first(where: { $0.filename == name }) != nil
                    },
                    onSave: { name in
                        list.renameItem(item: selectedItem, name: name)
                    }
                )
            }
        }
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
