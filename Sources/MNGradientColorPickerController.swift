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

@objc
public protocol MNGradientColorPickerControllerDelegate: AnyObject {
    /// Informs the delegate when a person selects a color.
    func gradientColorPickerViewController(_ controller: MNGradientColorPickerController, didSelect colors: [UIColor])
    @objc optional func gradientColorPickerViewControllerDidFinish(_ controller: MNGradientColorPickerController)
}

public class MNGradientColorPickerController: UIViewController {
    
    public weak var delegate: MNGradientColorPickerControllerDelegate?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    public var selectedColors: [UIColor]? = [.red, .red]
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var mainView: UIView!
    fileprivate var segmentedControl: UISegmentedControl!
    fileprivate var colorPickerView: ColorPickerView!
    fileprivate var editorView: UIView!
    
    fileprivate var showColorsButton: UIButton!
    fileprivate var previewView: ColorPreviewView!
    
    fileprivate var hex1Button: ColorPickerButton!
    fileprivate var hex2Button: ColorPickerButton!
    
    fileprivate var hexSwitchButton: UIButton!
    
    fileprivate var hex1HashLabel: UILabel!
    fileprivate var hex2HashLabel: UILabel!
    fileprivate var hex1TextField: UITextField!
    fileprivate var hex2TextField: UITextField!
    
    fileprivate var isHex1Active = true
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setupNavigationBar()
        setupViews()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            if self?.colorPickerView != nil {
                self?.setupConstraints()
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Views
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "Color Picker"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCancel))
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupMainView()
        setupSegmentedControl()
        setupColorPickerView()
        setupEditorView()
        setupSelectedColors()
        setupConstraints()
    }
    
    fileprivate func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    fileprivate func setupMainView() {
        mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(mainView)
        let mainViewHeightAnchorConstraint = mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        mainViewHeightAnchorConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainViewHeightAnchorConstraint
        ])
    }
    
    fileprivate func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Grid", "Spectrum", "Sliders"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 4),
            segmentedControl.leadingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            segmentedControl.trailingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
    
    fileprivate func setupColorPickerView() {
        colorPickerView = ColorPickerView()
        colorPickerView.delegate = self
        colorPickerView.clipsToBounds = true
        colorPickerView.layer.cornerRadius = 8
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(colorPickerView)
    }
    
    fileprivate func setupEditorView() {
        editorView = UIView()
        editorView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(editorView)
        
//        let subColorHex1 = color1.hexString
//        let subColorHex2 = color2.hexString
        
        previewView = ColorPreviewView()
//        previewView.backgroundLayer(with: [color1.cgColor, color2.cgColor])
        previewView.layer.cornerRadius = 12
        previewView.translatesAutoresizingMaskIntoConstraints = false
        editorView.addSubview(previewView)
        
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: editorView.safeAreaLayoutGuide.leadingAnchor),
            previewView.topAnchor.constraint(equalTo: editorView.topAnchor, constant: 12),
            previewView.widthAnchor.constraint(equalToConstant: 80),
            previewView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        hex1HashLabel = UILabel()
        hex2HashLabel = UILabel()
        [hex1HashLabel, hex2HashLabel].forEach {
            $0?.text = "#"
            $0?.textAlignment = .center
            $0?.font = .preferredFont(forTextStyle: .body)
            $0?.translatesAutoresizingMaskIntoConstraints = false
            editorView.addSubview($0!)
        }
        
        hex1TextField = UITextField()
//        hex1TextField.text = subColorHex1
        hex2TextField = UITextField()
//        hex2TextField.text = subColorHex2
        [hex1TextField, hex2TextField].forEach {
            $0?.delegate = self
            $0?.borderStyle = .roundedRect
            $0?.keyboardType = .asciiCapable
            $0?.autocorrectionType = .no
            $0?.autocapitalizationType = .allCharacters
            $0?.font = .preferredFont(forTextStyle: .body)
            $0?.textAlignment = .center
            $0?.addTarget(self, action: #selector(handleTextField(_:)), for: .editingChanged)
            $0?.translatesAutoresizingMaskIntoConstraints = false
            editorView.addSubview($0!)
        }
        
        NSLayoutConstraint.activate([
            hex1HashLabel.leadingAnchor.constraint(equalTo: previewView.trailingAnchor, constant: 12),
            hex1HashLabel.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
            hex1HashLabel.centerYAnchor.constraint(equalTo: hex1TextField.centerYAnchor),
            
            hex1TextField.leadingAnchor.constraint(equalTo: hex1HashLabel.trailingAnchor, constant: 12),
            hex1TextField.widthAnchor.constraint(lessThanOrEqualToConstant: 86),
            hex1TextField.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
            
            hex2TextField.trailingAnchor.constraint(equalTo: editorView.trailingAnchor),
            hex2TextField.widthAnchor.constraint(lessThanOrEqualToConstant: 86),
            hex2TextField.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
            
            hex2HashLabel.trailingAnchor.constraint(equalTo: hex2TextField.leadingAnchor, constant: -12),
            hex2HashLabel.centerYAnchor.constraint(equalTo: hex2TextField.centerYAnchor)
        ])
        
        hex1Button = ColorPickerButton(type: .system)
        hex1Button.isSelected = isHex1Active
//        hex1Button.color = UIColor(hex: "#"+subColorHex1)
        
        hex2Button = ColorPickerButton(type: .system)
//        hex2Button.color = UIColor(hex: "#"+subColorHex2)
        
        [hex1Button, hex2Button].forEach {
            $0?.addTarget(self, action: #selector(handleHexButton(_:)), for: .touchUpInside)
            $0?.translatesAutoresizingMaskIntoConstraints = false
            editorView.addSubview($0!)
        }
        
        NSLayoutConstraint.activate([
            hex1Button.widthAnchor.constraint(equalToConstant: 32),
            hex1Button.heightAnchor.constraint(equalToConstant: 32),
            hex1Button.topAnchor.constraint(equalTo: previewView.topAnchor),
            hex1Button.centerXAnchor.constraint(equalTo: hex1TextField.centerXAnchor),
            
            hex2Button.widthAnchor.constraint(equalToConstant: 32),
            hex2Button.heightAnchor.constraint(equalToConstant: 32),
            hex2Button.topAnchor.constraint(equalTo: previewView.topAnchor),
            hex2Button.centerXAnchor.constraint(equalTo: hex2TextField.centerXAnchor)
        ])
        
        hexSwitchButton = UIButton()
        hexSwitchButton.setImage(UIImage(systemName: "arrow.left.and.right"), for: .normal)
        hexSwitchButton.addTarget(self, action: #selector(handleHexSwitch(_:)), for: .touchUpInside)
        hexSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        editorView.addSubview(hexSwitchButton)
        
        NSLayoutConstraint.activate([
            hexSwitchButton.widthAnchor.constraint(equalToConstant: 32),
            hexSwitchButton.heightAnchor.constraint(equalToConstant: 32),
            hexSwitchButton.centerXAnchor.constraint(equalTo: editorView.centerXAnchor, constant: 52),
            hexSwitchButton.centerYAnchor.constraint(equalTo: hex1Button.centerYAnchor)
        ])
    }
    
    fileprivate func setupSelectedColors() {
        guard let selectedColors = selectedColors else { return }
        let cgColors = selectedColors.map { $0.cgColor }
        previewView.backgroundLayer(with: cgColors)
        
        if let hex1 = selectedColors.first?.hexString,
           let hex2 = selectedColors.last?.hexString {
            hex1TextField.text = selectedColors.first?.hexString
            hex1Button.color = UIColor(hex: "#"+hex1)
            hex2TextField.text = selectedColors.last?.hexString
            hex2Button.color = UIColor(hex: "#"+hex2)
            
            colorPickerView.setSelectedColor(with: selectedColors.first)
        }
    }
    
    fileprivate func setupConstraints() {
        colorPickerView.removeAllConstraints()
        editorView.removeAllConstraints()
        colorPickerView.colorGridView.gridCollectionView.collectionViewLayout.invalidateLayout()
        
        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.activate([
                colorPickerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                colorPickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
                colorPickerView.trailingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -6),
                colorPickerView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
                
                editorView.leadingAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 6),
                editorView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                editorView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
                editorView.heightAnchor.constraint(equalToConstant: 150)
            ])
        } else {
            let preferredContentSizeHeight = navigationController?.preferredContentSize.height ?? preferredContentSize.height
            
            NSLayoutConstraint.activate([
                colorPickerView.leadingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
                colorPickerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
                colorPickerView.trailingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
                colorPickerView.heightAnchor.constraint(equalToConstant: preferredContentSizeHeight == 0 ? view.bounds.height / 2.72 : preferredContentSizeHeight / 2),
                
                editorView.leadingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
                editorView.trailingAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
                editorView.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor, constant: 16),
                editorView.heightAnchor.constraint(equalToConstant: 150)
            ])
        }
    }
    
    // MARK: - Action Handlers
    
    @objc
    fileprivate func handleHexSwitch(_ button: UIButton) {
        let hex1Text = hex1TextField.text?.uppercased()
        
        hex1Button.color = UIColor(hex: "#"+(hex2TextField.text?.uppercased() ?? ""))
        hex2Button.color = UIColor(hex: "#"+(hex1Text ?? ""))
        
        hex1TextField.text = hex2TextField.text?.uppercased()
        hex2TextField.text = hex1Text
        previewView.backgroundLayer(with: [hex1Button.color!.cgColor, hex2Button.color!.cgColor])
//        #if targetEnvironment(macCatalyst)
//        if showingColorPicker {
//            CatalystAppManager.presentColorPicker(hex: isHex1Active ? hex1Button.color?.hexString ?? "" : hex2Button.color?.hexString ?? "")
//        }
//        #else
        colorPickerView.selectColor(with: isHex1Active ? hex1Button.color! : hex2Button.color!)
//        #endif
    }
    
    @objc
    fileprivate func handleHexButton(_ button: ColorPickerButton) {
        if hex1TextField.isFirstResponder || hex2TextField.isFirstResponder {
            _ = isHex1Active ? hex1TextField.becomeFirstResponder() : hex2TextField.becomeFirstResponder()
        }
        isHex1Active = button == hex1Button ? true : false
        hex1Button.isSelected = isHex1Active
        hex2Button.isSelected = !isHex1Active
        
        previewView.backgroundLayer(with: [hex1Button.color!.cgColor, hex2Button.color!.cgColor])
        
        let hexColor = isHex1Active ? hex1Button.color : hex2Button.color
        colorPickerView.setSelectedColor(with: hexColor)
    }
    
    @objc
    fileprivate func handleTextField(_ textField: UITextField) {
        isHex1Active = textField == hex1TextField ? true : false
        hex1Button.isSelected = isHex1Active
        hex2Button.isSelected = !isHex1Active
        
        guard let color = UIColor(hex: "#"+(textField.text ?? "")) else { return }
        if isHex1Active {
            hex1Button.color = color
        } else {
            hex2Button.color = color
        }
        previewView.backgroundLayer(with: [hex1Button.color!.cgColor, hex2Button.color!.cgColor])
        colorPickerView.selectColor(with: color)
    }
    
    @objc
    fileprivate func handleSegmentedControl(_ control: UISegmentedControl) {
        view.endEditing(true)
        
        let selectedIndex = segmentedControl.selectedSegmentIndex
        colorPickerView.colorGridView.alpha = selectedIndex == 0 ? 1 : 0
        colorPickerView.colorSpectrumView.alpha = selectedIndex == 1 ? 1 : 0
        colorPickerView.colorSlidersView.alpha = selectedIndex == 2 ? 1 : 0
    }
    
    @objc
    fileprivate func adjustKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
    }
    
    @objc
    fileprivate func appEnteredForeground(_ notification: Notification) {
        let color = isHex1Active ? hex1Button.color : hex2Button.color
        colorPickerView.setSelectedColor(with: color)
    }
    
    @objc
    fileprivate func handleCancel() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            (self.delegate?.gradientColorPickerViewControllerDidFinish?(self) ?? nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MNGradientColorPickerController: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 6
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

extension MNGradientColorPickerController: ColorPickerViewDelegate {
    
    public func colorChanged(color: UIColor) {
        if isHex1Active {
            hex1Button.color = color
            hex1TextField.text = color.hexString
        } else {
            hex2Button.color = color
            hex2TextField.text = color.hexString
        }
        guard let hex1Color = hex1Button.color,
              let hex2Color = hex2Button.color
        else { return }
        previewView.backgroundLayer(with: [hex1Color.cgColor, hex2Color.cgColor])
        delegate?.gradientColorPickerViewController(self, didSelect: [hex1Color, hex2Color])
    }
    
}
