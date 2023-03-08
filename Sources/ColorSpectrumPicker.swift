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

protocol ColorSpectrumPickerDelegate: AnyObject {
    func selectColor(with color: UIColor)
}

class ColorSpectrumPicker: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: ColorSpectrumPickerDelegate?
    
    private var colors: [CGColor] = {
        let hueValues = Array(0...359)
        return hueValues.map {
            UIColor(hue: CGFloat($0) / 359, saturation: 1, brightness: 1, alpha: 1).cgColor
        }
    }()
    
    fileprivate lazy var pickerOverlayView: PickerOverlayImageView = {
        let overlayView = PickerOverlayImageView()
        overlayView.layer.cornerRadius = 16
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    fileprivate var initialCenter = CGPoint()
    
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = colors
        
        addSubview(pickerOverlayView)
        NSLayoutConstraint.activate([
            pickerOverlayView.widthAnchor.constraint(equalToConstant: 32),
            pickerOverlayView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.delegate = self
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        tapGestureRecognizer.delegate = self
        
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
        
        setupColor(with: nil)
    }
    
    func setupColor(with color: UIColor?) {
        guard let color = color else { return }
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 1
        
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        DispatchQueue.main.async { [self] in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                let xHuePos = hue * self.bounds.width
                let xPos = xHuePos != self.pickerOverlayView.center.x ? self.pickerOverlayView.center.x : xHuePos
                print("xPos:", xHuePos, self.pickerOverlayView.center.x)
                let yPos = hue * self.bounds.height
                self.pickerOverlayView.center = CGPoint(x: xPos, y: yPos)
            }
        }
    }
    
    @objc
    fileprivate func handlePan(_ gestureRecognizer: UIGestureRecognizer) {
        let piece = pickerOverlayView
        let location = gestureRecognizer.location(in: self)
        
        if gestureRecognizer.state == .began {
            pickerOverlayView.center = gestureRecognizer.location(in: self)
            self.initialCenter = piece.center
        }

        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: location.x, y: location.y)
            piece.center = newCenter
            initialCenter = newCenter
        } else {
            piece.center = initialCenter
        }
        
        let cgValue = min(bounds.height, max(0, location.y)) / bounds.height
        let color = UIColor(hue: cgValue, saturation: 1, brightness: 1, alpha: 1)
        delegate?.selectColor(with: color)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGestureRecognizer && otherGestureRecognizer == panGestureRecognizer {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        tapGestureRecognizer = nil
        panGestureRecognizer = nil
    }
    
}
