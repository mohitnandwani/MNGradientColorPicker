//
//  ColorPickerView.swift
//  MNGradientColorPicker-SwiftUI
//
//  Created by Mohit Nandwani on 30/06/23.
//

import SwiftUI
import MNGradientColorPicker

struct ColorPickerView: View {
    
    @Binding var selectedColors: [Color]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            MNGradientColorPickerView(selectedColors: selectedColors.isEmpty ? nil : selectedColors) { colors in
                selectedColors = colors
            }
            .navigationTitle("Color Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColors: .constant([.red, .blue]))
    }
}
