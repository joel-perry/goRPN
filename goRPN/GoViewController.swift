//
//  GoViewController.swift
//  goRPN
//
//  Created by Joel Perry on 2/11/15.
//  Copyright (c) 2015 Joel Perry. All rights reserved.
//

import UIKit

class GoViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    let calc: GoCalculator<Double>
    var displayDecimalPlaces: Int
    var replaceDisplay: Bool
    
    required init?(coder aDecoder: NSCoder) {
        calc = GoCalculator()
        let savedStack = NSUserDefaults.standardUserDefaults().objectForKey("stack") as? [Double]
        calc.stack = savedStack ?? [ 0.0 ]
        
        let savedDecimalPlaces = NSUserDefaults.standardUserDefaults().objectForKey("decimalPlaces") as? Int
        displayDecimalPlaces = savedDecimalPlaces ?? 2
        
        replaceDisplay = true
        
        super.init(coder: aDecoder)
    }
    
    // MARK: UIView
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        let gradientLayer = CAGradientLayer(startColor: UIColor(hex: 0x3F4F5F), endColor: UIColor(hex: 0x1F2F3F))
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        updateDisplay()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSUserDefaults.standardUserDefaults().setObject(calc.stack, forKey: "stack")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: IBAction
    @IBAction func digitKeyPressed(sender: UIButton) {
        if replaceDisplay {
            display.text! = stringForTag(sender.tag)
            replaceDisplay = false
        } else {
            if sender.tag == 10 && display.text!.characters.contains(".") { return }
            display.text! += stringForTag(sender.tag)
        }
    }
    
    @IBAction func digitKeyLongPressed(sender: UILongPressGestureRecognizer) {
        displayDecimalPlaces = sender.view!.tag
        updateDisplay()
        NSUserDefaults.standardUserDefaults().setInteger(displayDecimalPlaces, forKey: "decimalPlaces")
    }
    
    @IBAction func operationKeyPressed(sender: UIButton) {
        if !replaceDisplay {
            calc.performOperation(.Push(display.text!.doubleValue))
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
        replaceDisplay = true
    }
    
    @IBAction func clearAllKeyPressed(sender: UIButton) {
        calc.stack.removeAll()
        calc.performOperation(.Push(0.0))
        updateDisplay()
        replaceDisplay = true
    }
    
    @IBAction func clearDisplayKeyPressed(sender: UIButton) {
        updateDisplay()
        replaceDisplay = true
    }
    
    // MARK: Utility
    func updateDisplay() {
        display.text! = calc.stack[0].decimalPlaces(displayDecimalPlaces)
    }
    
    func stringForTag(tag: Int) -> String {
        if (tag == 10) { return "." }
        return String(tag)
    }

}

