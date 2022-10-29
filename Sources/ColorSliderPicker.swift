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

protocol ColorSliderPickerDelegate: AnyObject {
    func selectColor(with color: UIColor?)
}

class ColorSliderPicker: UIView {
    
    weak var delegate: ColorSliderPickerDelegate?
    
    private var redColors: [CGColor] = {
        let rgbRedValues = Array(0...255)
        return rgbRedValues.map {
            UIColor(red: CGFloat($0), green: 0, blue: 0).cgColor
        }
    }()
    
    private var greenColors: [CGColor] = {
        let rgbGreenValues = Array(0...255)
        return rgbGreenValues.map {
            UIColor(red: 0, green: CGFloat($0), blue: 0).cgColor
        }
    }()
    
    private var blueColors: [CGColor] = {
        let rgbBlueValues = Array(0...255)
        return rgbBlueValues.map {
            UIColor(red: 0, green: 0, blue: CGFloat($0)).cgColor
        }
    }()
    
    private var colors: [CGColor] = {
        let hueValues = Array(0...359) //359
        return hueValues.map {
            UIColor(hue: CGFloat($0) / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
        }
    }()
    
    fileprivate lazy var redLabel: UILabel = {
        let label = UILabel()
        label.text = "RED"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var redValueTextField: UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextField(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var redSlider: RGBSlider = {
        let slider = RGBSlider()
        slider.addTarget(self, action: #selector(handleControl(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate lazy var greenLabel: UILabel = {
        let label = UILabel()
        label.text = "GREEN"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var greenValueTextField: UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextField(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var greenSlider: RGBSlider = {
        let slider = RGBSlider()
        slider.addTarget(self, action: #selector(handleControl(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.text = "BLUE"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var blueValueTextField: UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(handleTextField(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate lazy var blueSlider: RGBSlider = {
        let slider = RGBSlider()
        slider.addTarget(self, action: #selector(handleControl(_:)), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    @objc
    fileprivate func handleTextField(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField == redValueTextField {
            redSlider.currentValue = CGFloat(Double(text) ?? 0)
        } else if textField == blueValueTextField {
            blueSlider.currentValue = CGFloat(Double(text) ?? 0)
        } else {
            greenSlider.currentValue = CGFloat(Double(text) ?? 0)
        }
        updateSliderLayers()
    }
    
    @objc
    fileprivate func handleControl(_ control: RGBSlider) {
//        if control == redSlider {
//            redValueTextField.text = "\(redSlider.currentValue.rounded())".noTails()
//        } else if control == greenSlider {
//            greenValueTextField.text = "\(greenSlider.currentValue.rounded())".noTails()
//        } else {
//            blueValueTextField.text = "\(blueSlider.currentValue.rounded())".noTails()
//        }
        
        let rgbColor = UIColor(red: redSlider.currentValue / 255, green: greenSlider.currentValue / 255, blue: blueSlider.currentValue / 255, alpha: 1)
        delegate?.selectColor(with: rgbColor)
        
        updateSliderLayers()
    }
    
    func setupRedColors(green: CGFloat = 0, blue: CGFloat = 0) -> [CGColor] {
        let rgbArray = Array(0...255)
        return rgbArray.map { UIColor(red: CGFloat($0), green: green, blue: blue).cgColor }
    }
    
    func setupGreenColors(red: CGFloat = 0, blue: CGFloat = 0) -> [CGColor] {
        let rgbArray = Array(0...255)
        return rgbArray.map { UIColor(red: red, green: CGFloat($0), blue: blue).cgColor }
    }
    
    func setupBlueColors(red: CGFloat = 0, green: CGFloat = 0) -> [CGColor] {
        let rgbArray = Array(0...255)
        return rgbArray.map { UIColor(red: red, green: green, blue: CGFloat($0)).cgColor }
    }
    
    fileprivate func updateSliderLayers() {
        redSlider.setupLayer(with: setupRedColors(green: greenSlider.currentValue.rounded(), blue: blueSlider.currentValue.rounded()))
        blueSlider.setupLayer(with: setupBlueColors(red: redSlider.currentValue.rounded(), green: greenSlider.currentValue.rounded()))
        greenSlider.setupLayer(with: setupGreenColors(red: redSlider.currentValue.rounded(), blue: blueSlider.currentValue.rounded()))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let redView = UIView()
        [redLabel, redSlider, redValueTextField].forEach { redView.addSubview($0) }
        redSlider.setupLayer(with: redColors)
        
        NSLayoutConstraint.activate([
            redLabel.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            redLabel.topAnchor.constraint(equalTo: redView.topAnchor),
            
            redSlider.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            redSlider.topAnchor.constraint(equalTo: redLabel.bottomAnchor, constant: 8),
            redSlider.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -72),
            redSlider.heightAnchor.constraint(equalToConstant: 48),
            
            redValueTextField.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            redValueTextField.widthAnchor.constraint(equalToConstant: 64),
            redValueTextField.centerYAnchor.constraint(equalTo: redSlider.centerYAnchor)
        ])
        
        let greenView = UIView()
        [greenLabel, greenSlider, greenValueTextField].forEach { greenView.addSubview($0) }
        greenSlider.setupLayer(with: setupGreenColors())
        
        NSLayoutConstraint.activate([
            greenLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor),
            greenLabel.topAnchor.constraint(equalTo: greenView.topAnchor),
            
            greenSlider.leadingAnchor.constraint(equalTo: greenView.leadingAnchor),
            greenSlider.topAnchor.constraint(equalTo: greenLabel.bottomAnchor, constant: 8),
            greenSlider.trailingAnchor.constraint(equalTo: greenView.trailingAnchor, constant: -72),
            greenSlider.heightAnchor.constraint(equalToConstant: 48),
            
            greenValueTextField.trailingAnchor.constraint(equalTo: greenView.trailingAnchor),
            greenValueTextField.widthAnchor.constraint(equalToConstant: 64),
            greenValueTextField.centerYAnchor.constraint(equalTo: greenSlider.centerYAnchor)
        ])
        
        let blueView = UIView()
        [blueLabel, blueSlider, blueValueTextField].forEach { blueView.addSubview($0) }
        blueSlider.setupLayer(with: blueColors)
        
        NSLayoutConstraint.activate([
            blueLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            blueLabel.topAnchor.constraint(equalTo: blueView.topAnchor),
            
            blueSlider.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            blueSlider.topAnchor.constraint(equalTo: blueLabel.bottomAnchor, constant: 8),
            blueSlider.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -72),
            blueSlider.heightAnchor.constraint(equalToConstant: 48),
            
            blueValueTextField.trailingAnchor.constraint(equalTo: blueView.trailingAnchor),
            blueValueTextField.widthAnchor.constraint(equalToConstant: 64),
            blueValueTextField.widthAnchor.constraint(equalToConstant: 64),
            blueValueTextField.centerYAnchor.constraint(equalTo: blueSlider.centerYAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [redView, greenView, blueView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupColor(with: nil)
    }
    
    func setupColor(with color: UIColor?) {
        guard let rgb = color?.rgb else { return }
        
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self?.redSlider.currentValue = rgb.red
                self?.greenSlider.currentValue = rgb.green
                self?.blueSlider.currentValue = rgb.blue
                
                self?.redValueTextField.text = "\(rgb.red.rounded())".noTail
                self?.greenValueTextField.text = "\(rgb.green.rounded())".noTail
                self?.blueValueTextField.text = "\(rgb.blue.rounded())".noTail
                
                self?.updateSliderLayers()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ColorSliderPicker: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newText.starts(with: "0") && textField.text?.count ?? 0 >= 1 {
            textField.text?.remove(at: newText.startIndex)
        }
        
        if newText.isEmpty {
            return true
        } else if let intValue = Int(newText), intValue <= 255 {
            return true
        }
        return false
    }
    
}
