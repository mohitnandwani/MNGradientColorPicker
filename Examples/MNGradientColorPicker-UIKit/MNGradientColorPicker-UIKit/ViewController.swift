//
//  ViewController.swift
//  MNGradientColorPicker-UIKit
//
//  Created by Mohit Nandwani on 29/10/22.
//

import UIKit
import MNGradientColorPicker

class ViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectedColorPreview: SelectedColorPreview!
    @IBOutlet weak var gradientColorPickerButton: UIButton!
        
    let defaultGradientColors = [UIColor.red, UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.layer.cornerRadius = 24
        selectedColorPreview.layer.cornerRadius = 12
        
        let defaultCGColors = defaultGradientColors.map { $0.cgColor }
        (selectedColorPreview.layer as? CAGradientLayer)?.colors = defaultCGColors
    }
    
    @IBAction func didTapGradientColorPickerButton(_ sender: Any) {
        let gradientColorPickerController = MNGradientColorPickerController()
        gradientColorPickerController.delegate = self
        gradientColorPickerController.selectedColors = defaultGradientColors
        let navGradientColorPickerController = UINavigationController(rootViewController: gradientColorPickerController)
        self.present(navGradientColorPickerController, animated: true)
    }
    
}

extension ViewController: MNGradientColorPickerControllerDelegate {

    func gradientColorPickerViewController(_ controller: MNGradientColorPickerController, didSelect colors: [UIColor]) {
        guard let layer = selectedColorPreview.layer as? CAGradientLayer else { return }
        let cgColors = colors.map { $0.cgColor }
        layer.colors = cgColors
    }
    
    func gradientColorPickerViewControllerDidFinish(_ controller: MNGradientColorPickerController) {
        NSLog("Gradient Color Picker Dismissed")
    }

}
