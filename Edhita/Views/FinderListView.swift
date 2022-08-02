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
    @State private var isPresentedAddDialog = false
    @State private var isPresentedEditDialog = false
    @State private var isPresentedFilePrompt = false
    @State private var isPresentedDirectoryPrompt = false
    @State private var isPresentedDownloadPrompt = false
    @State private var isPresentedRenamePrompt = false
    @State private var isPresentedMoveList = false
    @State private var isPresentedInfo = false
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
                        isPresentedEditDialog = false
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
                            action: {
                                isPresentedAddDialog.toggle()
                            },
                            label: {
                                Image(systemName: "plus")
                            }
                        )
                        .confirmationDialog(
                            selectedItem?.url.lastPathComponent ?? "",
                            isPresented: $isPresentedAddDialog
                        ) {
                            Button("File") {
                                isPresentedFilePrompt.toggle()
                            }
                            Button("Directory") {
                                isPresentedDirectoryPrompt.toggle()
                            }
                            Button("Download") {
                                isPresentedDownloadPrompt.toggle()
                            }
                        }
                    }
                    if isEditing {
                        Button(
                            action: {
                                isPresentedEditDialog.toggle()
                            },
                            label: {
                                Image(systemName: "ellipsis")
                            }
                        )
                        .disabled(selectedItem == nil)
                        .confirmationDialog(
                            selectedItem?.url.lastPathComponent ?? "",
                            isPresented: $isPresentedEditDialog
                        ) {
                            Button("Rename") {
                                isPresentedRenamePrompt.toggle()
                            }
                            Button("Duplicate") {
                                withAnimation {
                                    list.duplicateItem(item: selectedItem)
                                }
                            }
                            Button("Move") {
                                isPresentedMoveList.toggle()
                            }
                            Button("Delete", role: .destructive) {
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(
                    action: {
                        isPresentedInfo.toggle()
                    },
                    label: {
                        Image(systemName: "gearshape")
                    }
                )
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
                    title: "Rename",
                    textLabel: "Name",
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
        .sheet(isPresented: $isPresentedFilePrompt) {
            NavigationView {
                PromptView(
                    title: "New File",
                    textLabel: "Name",
                    canSave: { name in
                        name.isEmpty || list.items.first(where: { $0.filename == name }) != nil
                    },
                    onSave: { name in
                        list.addItem(name: name, isDirectory: false)
                    },
                    text: ""
                )
            }
        }
        .sheet(isPresented: $isPresentedDirectoryPrompt) {
            NavigationView {
                PromptView(
                    title: "New Directory",
                    textLabel: "Name",
                    canSave: { name in
                        name.isEmpty || list.items.first(where: { $0.filename == name }) != nil
                    },
                    onSave: { name in
                        list.addItem(name: name, isDirectory: true)
                    },
                    text: ""
                )
            }
        }
        .sheet(isPresented: $isPresentedDownloadPrompt) {
            NavigationView {
                PromptView(
                    title: "Download",
                    textLabel: "URL",
                    canSave: { urlString in
                        guard let url = URL(string: urlString) else { return false }
                        return list.items.first(where: { $0.filename == url.lastPathComponent })
                            != nil
                    },
                    onSave: { urlString in
                        list.downloadItem(urlString: urlString)
                    },
                    text: "https://"
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
        .sheet(isPresented: $isPresentedInfo) {
            NavigationView {
                InfoView()
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
