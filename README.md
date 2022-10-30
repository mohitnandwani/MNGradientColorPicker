# MNGradientColorPicker 🎨

MNGradientColorPicker is a color picker for iOS. It allows you to pick gradient colors for your views.

![grid-view](https://user-images.githubusercontent.com/28500428/198872326-2cffc67b-6f48-496b-9e0d-fc31aa42df57.png)
![spectrum-view](https://user-images.githubusercontent.com/28500428/198872340-1e8188fb-400a-446f-86de-27d04fc564bf.png)
![sliders-view](https://user-images.githubusercontent.com/28500428/198872348-4350fe90-dc4b-4321-aa9d-c60d0b3a7045.png)

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

> Note: Use `UINavigationController` to present Gradient Color Picker for better layout.

You can also view or download UIKit example for demo purposes.

## Live Demo

My app [Subtrack](https://apps.apple.com/app/id1519946553) (A Subscription Tracker) is using MNGradientColorPicker for color customisation. You can download it and try it on your multiple devices to check it out.

## Credits

- Mohit Nandwani ([@iMohitnandwani](https://twitter.com/iMohitNandwani))

## License

MNGradientColorPicker is released under the MIT license. See LICENSE for details.
