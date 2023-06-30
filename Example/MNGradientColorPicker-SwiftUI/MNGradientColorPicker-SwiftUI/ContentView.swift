//
//  ContentView.swift
//  MNGradientColorPicker-SwiftUI
//
//  Created by Mohit Nandwani on 30/06/23.
//

import SwiftUI
import MNGradientColorPicker

struct ContentView: View {
    
    @State
    private var selectedColors: [Color] = [.red, .blue]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("MNGradientColorPicker")
                .foregroundColor(.primary)
                .bold()
            LinearGradient(gradient: Gradient(colors: selectedColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(16)
                .padding(.horizontal, 16)
            NavigationLink(destination: ColorPickerView()) {
                Text("Show Gradient Color Picker")
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
