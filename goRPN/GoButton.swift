//
//  GoButton.swift
//  goRPN
//
//  Created by Joel Perry on 10/10/15.
//  Copyright © 2015 Joel Perry. All rights reserved.
//

import UIKit

class GoButton: UIButton {
    override func awakeFromNib() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.0
        layer.cornerRadius = frame.size.height * 0.1
    }
}
