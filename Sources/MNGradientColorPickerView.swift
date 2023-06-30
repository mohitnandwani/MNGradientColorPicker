//
//  MNGradientColorPicker
//
//  Copyright (c) 2022-Present Mohit Nandwani - https://github.com/mohitnandwani/MNGradientColorPicker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import SwiftUI

public struct MNGradientColorPickerView: UIViewControllerRepresentable {
    
    let mnGradientColorPickerController = MNGradientColorPickerController()
    
    var selectedColors: [Color]?
    var onColorsSelection: ([Color]) -> Void
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        return mnGradientColorPickerController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    public func makeCoordinator() -> MNGradientColorPickerCoordinator {
        MNGradientColorPickerCoordinator(colorPickerController: mnGradientColorPickerController, selectedColors: selectedColors, onColorsSelection: onColorsSelection)
    }
    
    public  class MNGradientColorPickerCoordinator: NSObject, MNGradientColorPickerControllerDelegate {
        
        var onColorsSelection: ([Color]) -> Void
        var onDismiss: (() -> Void)?
        
        public init(colorPickerController: MNGradientColorPickerController, selectedColors: [Color]?, onColorsSelection: @escaping ([Color]) -> Void) {
            self.onColorsSelection = onColorsSelection
            colorPickerController.selectedColors = selectedColors?.map({ $0.uiColor() })
            super.init()
            colorPickerController.delegate = self
        }
        
        public func gradientColorPickerViewController(_ controller: MNGradientColorPickerController, didSelect colors: [UIColor]) {
            onColorsSelection(colors.map({ Color($0) }))
        }
        
    }
    
}
