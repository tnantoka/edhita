//
//  PlaceholderView.swift
//  Edhita
//
//  Created by Tatsuya Tobioka on 2022/08/05.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("No item selected.")
                .font(.title2)
            Spacer()
        }
    }
}

struct PlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderView()
    }
}
