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

class RGBSlider: UIControl {
    
    var currentValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 255
    
    fileprivate lazy var pickerOverlayImageView: PickerOverlayImageView = {
        let overlayView = PickerOverlayImageView()
        overlayView.layer.cornerRadius = 24
        return overlayView
    }()
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayer(with: nil)
        layer.cornerRadius = 24
        
        addSubview(pickerOverlayImageView)
        pickerOverlayImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerOverlayImageView.widthAnchor.constraint(equalToConstant: 48),
            pickerOverlayImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func setupLayer(with colors: [CGColor]?) {
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
    }
    
    private var previousLocation = CGPoint()
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        if pickerOverlayImageView.frame.contains(previousLocation) {
            pickerOverlayImageView.isHighlighted = true
        }
        return pickerOverlayImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        if pickerOverlayImageView.isHighlighted {
            currentValue += deltaValue
            currentValue = boundValue(currentValue, toMinimumValue: minimumValue, maximumValue: maximumValue)
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        sendActions(for: .valueChanged)
        return true
    }
    
    private func updateLayerFrames() {
        pickerOverlayImageView.frame = CGRect(origin: thumbOriginForValue(currentValue.rounded()), size: CGSize(width: 48, height: 48))
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - 48) * value
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) / 255
        return CGPoint(x: x, y: 0)
    }
    
    private func boundValue(_ value: CGFloat, toMinimumValue minimumValue: CGFloat, maximumValue: CGFloat) -> CGFloat {
        return min(max(value, minimumValue), maximumValue)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        pickerOverlayImageView.isHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
