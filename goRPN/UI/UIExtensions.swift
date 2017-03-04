//
//  GoStructures.swift
//  goRPN
//
//  Created by Joel Perry on 2/11/15.
//  Copyright (c) Joel Perry. All rights reserved.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.
//

import UIKit

extension Double {
    func toString(decimalPlaces p: Int) -> String {
        return String(format: "%.\(p)f", self)
    }
}

extension String {
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
