//
//  InfoView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/01.
//

import SwiftUI

struct InfoView: View {
    @State var keyboardAccessory = true
    @State var isPresentedAcknowledgments = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                Toggle("Keyboard Accessory", isOn: $keyboardAccessory)
                NavigationLink("Font") {
                    FontSettingsView()
                }
            }
            Section {
                Button("Acknowledgments") {
                    isPresentedAcknowledgments.toggle()
                }
            }
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $isPresentedAcknowledgments) {
            SafariView(url: URL(string: "https://google.com/")!)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InfoView()
        }
    }
}
