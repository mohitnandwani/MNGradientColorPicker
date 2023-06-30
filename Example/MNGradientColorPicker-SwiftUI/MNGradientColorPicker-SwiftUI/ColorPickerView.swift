//
//  ColorPickerView.swift
//  MNGradientColorPicker-SwiftUI
//
//  Created by Mohit Nandwani on 30/06/23.
//

import SwiftUI
import MNGradientColorPicker

struct ColorPickerView: View {
    
//    @Binding var selectedColors: [Color]?
    
    var body: some View {
        NavigationView {
            MNGradientColorPickerView { colors in
                //
            }
            .navigationTitle("Color Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("dismiss")
//                        dismiss()
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
        ColorPickerView()
    }
}
