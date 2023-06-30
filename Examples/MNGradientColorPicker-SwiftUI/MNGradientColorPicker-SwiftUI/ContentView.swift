//
//  ContentView.swift
//  MNGradientColorPicker-SwiftUI
//
//  Created by Mohit Nandwani on 30/06/23.
//

import SwiftUI
import MNGradientColorPicker

struct ContentView: View {
    
    @State private var selectedColors: [Color] = [.red, .blue]
    @State private var showingColorPicker = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("MNGradientColorPicker")
                .foregroundColor(.primary)
                .font(.headline)
            LinearGradient(gradient: Gradient(colors: selectedColors), startPoint: .top, endPoint: .bottom)
                .cornerRadius(16)
                .padding(.horizontal, 16)
            Button("Show Gradient Color Picker") {
                self.showingColorPicker = true
            }.sheet(isPresented: $showingColorPicker) {
                ColorPickerView(selectedColors: $selectedColors)
            }
            Spacer()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .frame(width: 300, height: 300, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
