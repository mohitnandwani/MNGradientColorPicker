//
//  ContentView.swift
//  MNGradientColorPicker-SwiftUI
//
//  Created by Mohit Nandwani on 30/06/23.
//

import SwiftUI
import MNGradientColorPicker

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
