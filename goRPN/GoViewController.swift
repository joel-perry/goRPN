//
//  GoViewController.swift
//  goRPN
//
//  Created by Joel Perry on 2/11/15.
//  Copyright (c) 2015 Joel Perry. All rights reserved.
//

import UIKit

class GoViewController: UIViewController {
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var tLabel: UILabel!
    
    var calc: GoCalculator<Double>
    private var displayDecimalPlaces: Int
    private var replaceX: Bool
    
    required init?(coder aDecoder: NSCoder) {
        calc = GoCalculator()
        calc.loadStack()
        
        let savedDecimalPlaces = NSUserDefaults.standardUserDefaults().objectForKey("decimalPlaces") as? Int
        displayDecimalPlaces = savedDecimalPlaces ?? 2
        replaceX = true
        
        super.init(coder: aDecoder)
    }
    
    // MARK: UIView
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        let gradientLayer = CAGradientLayer.backgroundGradient()
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: IBAction
    @IBAction func digitKeyPressed(sender: UIButton) {
        if replaceX {
            xLabel.text! = stringForTag(sender.tag)
            replaceX = false
        } else {
            if sender.tag == 10 && xLabel.text!.characters.contains(".") { return }
            xLabel.text! += stringForTag(sender.tag)
        }
    }
    
    @IBAction func digitKeyLongPressed(sender: UILongPressGestureRecognizer) {
        displayDecimalPlaces = sender.view!.tag
        updateDisplay()
        NSUserDefaults.standardUserDefaults().setInteger(displayDecimalPlaces, forKey: "decimalPlaces")
    }
    
    @IBAction func operationKeyPressed(sender: UIButton) {
        if !replaceX {
            calc.performOperation(.Push(xLabel.text!.doubleValue))
        }
        
        switch sender.tag {
        case 101:
            calc.performOperation(.Infix(+))
        case 102:
            calc.performOperation(.Infix(-))
        case 103:
            calc.performOperation(.Infix(*))
        case 104:
            calc.performOperation(.Infix(/))
        case 201:
            calc.performOperation(.Prefix(-))
        case 202:
            calc.performOperation(.Push(M_PI))
        case 203:
            return
        case 204:
            calc.performOperation(.Prefix(√))
        case 205:
            calc.performOperation(.Infix(**))
        default:
            break
        }
        updateDisplay()
        replaceX = true
    }
    
    @IBAction func clearAllKeyPressed(sender: UIButton) {
        calc.clearStack()
        updateDisplay()
        replaceX = true
    }
    
    @IBAction func clearDisplayKeyPressed(sender: UIButton) {
        updateDisplay()
        replaceX = true
    }
    
    // MARK: Utility
    private func updateDisplay() {
        xLabel.text! = calc.xRegister.decimalPlaces(displayDecimalPlaces)
        yLabel.text! = "y: " + calc.yRegister.decimalPlaces(displayDecimalPlaces)
        zLabel.text! = "z: " + calc.zRegister.decimalPlaces(displayDecimalPlaces)
        tLabel.text! = "t: " + calc.tRegister.decimalPlaces(displayDecimalPlaces)
    }
    
    private func stringForTag(tag: Int) -> String {
        if (tag == 10) { return "." }
        return String(tag)
    }

}

