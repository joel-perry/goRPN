//
//  GoCalculator.swift
//  goRPN
//
//  Created by Joel Perry on 10/10/15.
//  Copyright © 2015 Joel Perry. All rights reserved.
//

import Foundation

enum StackOperation<T: IntegerLiteralConvertible> {
    case Push(T)
    case Infix((lhs: T, rhs: T) -> T)
    case Prefix((number: T) -> T)
}

class GoCalculator<T: IntegerLiteralConvertible> {
    // MARK: Public
    var xRegister: T {
        get { return stack.count > 0 ? stack[0] : 0 }
    }
    
    var yRegister: T {
        get { return stack.count > 1 ? stack[1] : 0 }
    }
    
    var zRegister: T {
        get { return stack.count > 2 ? stack[2] : 0 }
    }
    
    var tRegister: T {
        get { return stack.count > 3 ? stack[3] : 0 }
    }
    
    func loadStack() {
        let savedStack = NSUserDefaults.standardUserDefaults().objectForKey("stack") as? [T]
        stack = savedStack ?? newStack()
    }
    
    func saveStack() {
        NSUserDefaults.standardUserDefaults().setObject(stack as? AnyObject, forKey: "stack")
    }
    
    func clearStack() {
        stack = newStack()
    }
    
    func performOperation(operation: StackOperation<T>) {
        switch operation {
        case .Push(let value):
            stack.insert(value, atIndex: 0)
        case .Infix(let op):
            if stack.count < 2 { return }
            let right = stack.removeAtIndex(0)
            let left = stack.removeAtIndex(0)
            stack.insert(op(lhs: left, rhs: right), atIndex: 0)
        case .Prefix(let op):
            stack.insert(op(number: stack.removeAtIndex(0)), atIndex: 0)
        }
        balanceStack()
    }
    
    // MARK: Private
    private var stack = [T]()
    
    // This currently limits stack size to 4 (like the HP-16c).
    // Change first line to '>=' to enable unlimited stack size.
    private func balanceStack() {
        if stack.count == 4 { return }
        if stack.count < 4 { stack.append(stack.last!) }
        else { stack.removeLast() }
        balanceStack()
    }
    
    private func newStack() -> [T] {
        return [T](count: 4, repeatedValue: 0)
    }
}

// MARK: Operators
prefix operator √ {}
prefix func √ (number: Double) -> Double {
    return sqrt(number)
}

infix operator ** { associativity left precedence 170 }
func ** (lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}
