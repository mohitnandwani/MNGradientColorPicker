# MNGradientColorPicker 🎨

MNGradientColorPicker is a color picker for iOS. It allows you to pick gradient colors for your views.

## Requirements

- iOS 13.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate MNGradientColorPicker into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mohitnandwani/MNGradientColorPicker.git", .upToNextMajor(from: "1.0"))
]
```

### Manually

If you prefer not to use dependency managers, you can integrate MNGradientColorPicker into your project manually.

## Usage

### UIKit

```swift
import UIKit
import MNGradientColorPicker

func presentGradientColorPicker() {
    let gradientColorPickerController = MNGradientColorPickerController()
        gradientColorPickerController.selectedColors = // use this to preset selected colors
    gradientColorPickerController.delegate = self // set delegate to get the selected colors
    let navGradientColorPickerController = UINavigationController(rootViewController: gradientColorPickerController)
    self.present(gradientColorPickerController, animated: true)
}

// Delegation Method to get selected colors
extension ViewController: MNGradientColorPickerControllerDelegate {
    func gradientColorPickerViewController(_ controller: MNGradientColorPickerController, didSelect colors: [UIColor]) {
        guard let layer = selectedColorPreview.layer as? CAGradientLayer
        else { return }
        let cgColors = colors.map { $0.cgColor }
        layer.colors = cgColors
    }
    
    func gradientColorPickerViewControllerDidFinish(_ controller: MNGradientColorPickerController) {
        NSLog("Gradient Color Picker Dismissed")
    }
}
```

You can also view or download UIKit example for demo purposes.

## Credits

- Mohit Nandwani ([@iMohitnandwani](https://twitter.com/iMohitNandwani))

## License

MNGradientColorPicker is released under the MIT license. See LICENSE for details.
