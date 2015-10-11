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
    
    let calc: GoCalculator<Double>
    var displayDecimalPlaces: Int
    var replaceX: Bool
    
    required init?(coder aDecoder: NSCoder) {
        calc = GoCalculator()
        
        let savedDecimalPlaces = NSUserDefaults.standardUserDefaults().objectForKey("decimalPlaces") as? Int
        displayDecimalPlaces = savedDecimalPlaces ?? 2
        
        replaceX = true
        
        super.init(coder: aDecoder)
        
        let savedStack = NSUserDefaults.standardUserDefaults().objectForKey("stack") as? [Double]
        calc.stack = savedStack ?? calc.newStack()
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
        calc.stack = calc.newStack()
        updateDisplay()
        replaceX = true
    }
    
    @IBAction func clearDisplayKeyPressed(sender: UIButton) {
        updateDisplay()
        replaceX = true
    }
    
    // MARK: Utility
    func updateDisplay() {
        xLabel.text! = calc.stack[0].decimalPlaces(displayDecimalPlaces)
        yLabel.text! = "Y: " + calc.stack[1].decimalPlaces(displayDecimalPlaces)
        zLabel.text! = "Z: " + calc.stack[2].decimalPlaces(displayDecimalPlaces)
        tLabel.text! = "T: " + calc.stack[3].decimalPlaces(displayDecimalPlaces)
    }
    
    func stringForTag(tag: Int) -> String {
        if (tag == 10) { return "." }
        return String(tag)
    }

}

