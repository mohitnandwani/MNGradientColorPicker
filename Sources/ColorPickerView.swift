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

public protocol ColorPickerViewDelegate: AnyObject {
    func colorChanged(color: UIColor?, value: String)
}

public class ColorPickerView: UIView {
    
    public weak var delegate: ColorPickerViewDelegate?
    
    lazy var colorGridView: ColorGridPicker = {
        let gridView = ColorGridPicker()
        gridView.alpha = 1
        gridView.delegate = self
        gridView.clipsToBounds = true
        gridView.layer.cornerRadius = 8
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()
    
    lazy var colorSpectrumView: ColorSpectrumPicker = {
        let spectrumView = ColorSpectrumPicker()
        spectrumView.alpha = 0
        spectrumView.delegate = self
        spectrumView.clipsToBounds = true
        spectrumView.layer.cornerRadius = 8
        spectrumView.translatesAutoresizingMaskIntoConstraints = false
        return spectrumView
    }()
    
    lazy var colorSlidersView: ColorSliderPicker = {
        let slidersView = ColorSliderPicker()
        slidersView.alpha = 0
        slidersView.delegate = self
        slidersView.clipsToBounds = true
        slidersView.layer.cornerRadius = 8
        slidersView.translatesAutoresizingMaskIntoConstraints = false
        return slidersView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerViews()
    }
    
    fileprivate func setupPickerViews() {
        addSubview(colorGridView)
        addSubview(colorSpectrumView)
        addSubview(colorSlidersView)
        
        NSLayoutConstraint.activate([
            colorGridView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorGridView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorGridView.topAnchor.constraint(equalTo: topAnchor),
            colorGridView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setSelectedColor(with color: UIColor?) {
        colorGridView.setupColor(with: color)
        colorSpectrumView.setupColor(with: color)
        colorSlidersView.setupColor(with: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ColorPickerView: ColorGridPickerDelegate, ColorSpectrumPickerDelegate, ColorSliderPickerDelegate {
    
    func selectColor(with color: UIColor?) {
        setSelectedColor(with: color)
        delegate?.colorChanged(color: color, value: "")
    }
    
}
