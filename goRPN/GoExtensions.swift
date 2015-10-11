//
//  GoStructures.swift
//  goRPN
//
//  Created by Joel Perry on 2/11/15.
//  Copyright (c) 2015 Joel Perry. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func decimalPlaces(p: Int) -> String {
        return String(format: "%.\(p)f", self)
    }
    func asBinary() -> String {
        return String(Int(self), radix: 2)
    }
    func asOctal() -> String {
        return String(Int(self), radix: 8)
    }
    func asHexadecimal() -> String {
        return String(Int(self), radix: 16)
    }
    func stringValue() -> String {
        return String(format: "%f", self)
    }
}

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
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

extension CAGradientLayer {
    convenience init(startColor: UIColor, endColor: UIColor) {
        self.init()
        let colors = [ startColor.CGColor, endColor.CGColor ]
        self.colors = colors
        self.startPoint = CGPointMake(0.5, 0.0)
        self.endPoint = CGPointMake(0.5, 1.0)
    }
}
