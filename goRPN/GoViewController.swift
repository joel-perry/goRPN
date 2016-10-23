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
    fileprivate var displayDecimalPlaces: Int
    fileprivate var replaceX: Bool
    
    required init?(coder aDecoder: NSCoder) {
        calc = GoCalculator()
        calc.loadStack()
        
        let savedDecimalPlaces = UserDefaults.standard.object(forKey: "decimalPlaces") as? Int
        displayDecimalPlaces = savedDecimalPlaces ?? 2
        replaceX = true
        
        super.init(coder: aDecoder)
    }
    
    // MARK: UIView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        let gradientLayer = CAGradientLayer.backgroundGradient()
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: IBAction
    @IBAction func digitKeyPressed(_ sender: UIButton) {
        if replaceX {
            xLabel.text! = stringForTag(sender.tag)
            replaceX = false
        } else {
            if sender.tag == 10 && xLabel.text!.characters.contains(".") { return }
            xLabel.text! += stringForTag(sender.tag)
        }
    }
    
    @IBAction func digitKeyLongPressed(_ sender: UILongPressGestureRecognizer) {
        displayDecimalPlaces = sender.view!.tag
        updateDisplay()
        UserDefaults.standard.set(displayDecimalPlaces, forKey: "decimalPlaces")
    }
    
    @IBAction func operationKeyPressed(_ sender: UIButton) {
        if !replaceX {
            calc.performOperation(.push(xLabel.text!.doubleValue))
        }
        
        switch sender.tag {
        case 101:
            calc.performOperation(.infix(+))
        case 102:
            calc.performOperation(.infix(-))
        case 103:
            calc.performOperation(.infix(*))
        case 104:
            calc.performOperation(.infix(/))
        case 201:
            calc.performOperation(.prefix(-))
        case 202:
            calc.performOperation(.push(M_PI))
        case 203:
            return
        case 204:
            calc.performOperation(.prefix(√))
        case 205:
            calc.performOperation(.infix(**))
        default:
            break
        }
        updateDisplay()
        replaceX = true
    }
    
    @IBAction func clearAllKeyPressed(_ sender: UIButton) {
        calc.clearStack()
        updateDisplay()
        replaceX = true
    }
    
    @IBAction func clearDisplayKeyPressed(_ sender: UIButton) {
        updateDisplay()
        replaceX = true
    }
    
    // MARK: Utility
    fileprivate func updateDisplay() {
        xLabel.text! = calc.xRegister.decimalPlaces(displayDecimalPlaces)
        yLabel.text! = "y: " + calc.yRegister.decimalPlaces(displayDecimalPlaces)
        zLabel.text! = "z: " + calc.zRegister.decimalPlaces(displayDecimalPlaces)
        tLabel.text! = "t: " + calc.tRegister.decimalPlaces(displayDecimalPlaces)
    }
    
    fileprivate func stringForTag(_ tag: Int) -> String {
        if (tag == 10) { return "." }
        return String(tag)
    }

}

