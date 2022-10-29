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

class ColorPickerGridCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ColorPickerGridCell"
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.systemBackground.cgColor : nil
            layer.borderWidth = isSelected ? 2 : 0
            layer.cornerRadius = isSelected ? 2 : 0
        }
    }
    
    fileprivate var hoveGestureRecognizer: UIHoverGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hoveGestureRecognizer = UIHoverGestureRecognizer(target: self, action: #selector(hovering(_:)))
        addGestureRecognizer(hoveGestureRecognizer)
    }
    
    @objc
    fileprivate func hovering(_ recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            UIView.transition(with: self, duration: 0.1, options: .curveEaseInOut) {
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 2
                self.layer.borderColor = UIColor.systemBackground.cgColor
            }
        default:
            UIView.transition(with: self, duration: 0.1, options: .curveEaseInOut) {
                self.layer.borderWidth = 0
                self.layer.cornerRadius = 0
                self.layer.borderColor = .none
            }
        }
    }
    
    deinit {
        removeGestureRecognizer(hoveGestureRecognizer)
        hoveGestureRecognizer = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
