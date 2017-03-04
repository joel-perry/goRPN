//
//  GoButton.swift
//  goRPN
//
//  Created by Joel Perry on 10/10/15.
//  Copyright (c) Joel Perry. All rights reserved.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.
//

import UIKit

class GoButton: UIButton {
    override func awakeFromNib() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        setTitleColor(UIColor.white, for: UIControlState())
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = frame.size.height * 0.1
        
        imageView?.contentMode = .scaleAspectFit
    }
}
