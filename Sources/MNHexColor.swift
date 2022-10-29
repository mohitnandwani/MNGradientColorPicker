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

import Foundation

public struct MNHexColor: Hashable {
    
    let id = UUID()
    let hex: String
    
    init(hex: String) {
        self.hex = hex
    }
    
    public static func == (lhs: MNHexColor, rhs: MNHexColor) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

public extension MNHexColor {
    
    static var colors: [MNHexColor] = [
        .init(hex: "#ffffff"),
        .init(hex: "#ebebeb"),
        .init(hex: "#d6d6d6"),
        .init(hex: "#c2c2c2"),
        .init(hex: "#adadad"),
        .init(hex: "#999999"),
        .init(hex: "#858585"),
        .init(hex: "#707070"),
        .init(hex: "#5c5c5c"),
        .init(hex: "#474747"),
        .init(hex: "#333333"),
        .init(hex: "#000000"),
        .init(hex: "#14364b"),
        .init(hex: "#081c54"),
        .init(hex: "#0f0538"),
        .init(hex: "#2a093b"),
        .init(hex: "#370c1b"),
        .init(hex: "#541107"),
        .init(hex: "#532009"),
        .init(hex: "#53350d"),
        .init(hex: "#523e0f"),
        .init(hex: "#65611b"),
        .init(hex: "#505518"),
        .init(hex: "#2b3d16"),
        .init(hex: "#1e4c63"),
        .init(hex: "#102e76"),
        .init(hex: "#180b4f"),
        .init(hex: "#3f1256"),
        .init(hex: "#4e1629"),
        .init(hex: "#781e0e"),
        .init(hex: "#722f10"),
        .init(hex: "#734c16"),
        .init(hex: "#73591a"),
        .init(hex: "#8c8629"),
        .init(hex: "#707625"),
        .init(hex: "#3f5623"),
        .init(hex: "#2f6c8c"),
        .init(hex: "#1941a3"),
        .init(hex: "#280b72"),
        .init(hex: "#591e78"),
        .init(hex: "#6f223d"),
        .init(hex: "#a62c17"),
        .init(hex: "#a0461a"),
        .init(hex: "#a06b23"),
        .init(hex: "#9f7d28"),
        .init(hex: "#c3bc3c"),
        .init(hex: "#9da536"),
        .init(hex: "#587934"),
        .init(hex: "#3d8ab0"),
        .init(hex: "#2355ce"),
        .init(hex: "#331b8e"),
        .init(hex: "#720898"),
        .init(hex: "#8d234f"),
        .init(hex: "#d03a20"),
        .init(hex: "#ca5a24"),
        .init(hex: "#c8872e"),
        .init(hex: "#c99f35"),
        .init(hex: "#f3ec4e"),
        .init(hex: "#c6d147"),
        .init(hex: "#729c44"),
        .init(hex: "#479fd3"),
        .init(hex: "#285ff5"),
        .init(hex: "#4724ab"),
        .init(hex: "#8c33b6"),
        .init(hex: "#aa395d"),
        .init(hex: "#eb512e"),
        .init(hex: "#ed732e"),
        .init(hex: "#f3af3d"),
        .init(hex: "#f5c944"),
        .init(hex: "#fdfb67"),
        .init(hex: "#ddeb5c"),
        .init(hex: "#86b953"),
        .init(hex: "#5ac4f7"),
        .init(hex: "#4f85f6"),
        .init(hex: "#5832e2"),
        .init(hex: "#af42eb"),
        .init(hex: "#d44a7a"),
        .init(hex: "#ed6c59"),
        .init(hex: "#ef8c56"),
        .init(hex: "#f3b757"),
        .init(hex: "#f6cd5b"),
        .init(hex: "#fef781"),
        .init(hex: "#e6ef7a"),
        .init(hex: "#a3d16e"),
        .init(hex: "#78d3f8"),
        .init(hex: "#7fa6f8"),
        .init(hex: "#7e52f5"),
        .init(hex: "#c45ff6"),
        .init(hex: "#de789d"),
        .init(hex: "#f09286"),
        .init(hex: "#f2a984"),
        .init(hex: "#f6c983"),
        .init(hex: "#f9da85"),
        .init(hex: "#fef9a1"),
        .init(hex: "#ebf29b"),
        .init(hex: "#badc94"),
        .init(hex: "#a5e1fa"),
        .init(hex: "#adc5fa"),
        .init(hex: "#ab8df7"),
        .init(hex: "#d796f8"),
        .init(hex: "#e8a7bf"),
        .init(hex: "#f4b8b1"),
        .init(hex: "#f6c7af"),
        .init(hex: "#f9daae"),
        .init(hex: "#fae5af"),
        .init(hex: "#fefbc0"),
        .init(hex: "#f3f7be"),
        .init(hex: "#d2e7ba"),
        .init(hex: "#d2effd"),
        .init(hex: "#d6e2fc"),
        .init(hex: "#d6cafa"),
        .init(hex: "#e9cbfb"),
        .init(hex: "#f3d4e0"),
        .init(hex: "#f9dcd9"),
        .init(hex: "#fae3d8"),
        .init(hex: "#fcedd7"),
        .init(hex: "#fdf2d8"),
        .init(hex: "#fefce0"),
        .init(hex: "#f8fade"),
        .init(hex: "#e2eed6")
    ]
    
}
