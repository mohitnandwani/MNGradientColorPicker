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

extension UIColor {
    
    /// Convert RGB to Hue
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r = red / 255
        let g = green / 255
        let b = blue / 255
        
        let minValue: CGFloat = min(r, g, b)
        let maxValue: CGFloat = max(r, g, b)
        let delta: CGFloat = maxValue - minValue
        
        var hue:CGFloat = 0
        
        if delta != 0 {
            if r == maxValue {
                hue = (g - b) / delta
            } else if g == maxValue {
                hue = 2 + (b-r) / delta
            } else {
                hue = 4 + (r-g) / delta
            }
            
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        
        let saturation = maxValue == 0 ? 0 : (delta / maxValue)
        let brightness = maxValue
        
        self.init(hue: hue/360, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red*255, green*255, blue*255)
    }
    
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[safe: 0] ?? 0.0
        let g: CGFloat = components?[safe: 1] ?? 0.0
        let b: CGFloat = components?[safe: 2] ?? 0.0

        let hexString = String(format: "%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString.uppercased()
    }
    
    convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }

        return nil
    }
    
}

extension String {
    var noTail: String {
        return replacingOccurrences(of: ".0*$", with: "", options: .regularExpression)
    }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}

extension UIView {
    func removeAllConstraints() {
        if let superview = self.superview {
            self.removeFromSuperview()
            superview.addSubview(self)
        }
    }
}
