//
//  GoCalculator.swift
//  goRPN
//
//  Created by Joel Perry on 10/10/15.
//  Copyright © 2015 Joel Perry. All rights reserved.
//

import Foundation

// MARK: NumberConvertible
protocol NumberConvertible {
    init(_ value: Int)
    init(_ value: Float)
    init(_ value: Double)
}

extension NumberConvertible {
    func convert<T: NumberConvertible>() -> T {
        switch self {
        case let x as Float:
            return T(x)
        case let x as Int:
            return T(x)
        case let x as Double:
            return T(x)
        default:
            return T(0)
        }
    }
}

extension Double: NumberConvertible {}
extension Float: NumberConvertible {}
extension Int: NumberConvertible {}

enum StackOperation<T: NumberConvertible> {
    case Push(T)
    case Infix((lhs: T, rhs: T) -> T)
    case Prefix((number: T) -> T)
}

class GoCalculator<T: NumberConvertible> {
    // MARK: Public
    var xRegister: T { return stack.count > 0 ? stack[0] : 0.convert() }
    var yRegister: T { return stack.count > 1 ? stack[1] : 0.convert() }
    var zRegister: T { return stack.count > 2 ? stack[2] : 0.convert() }
    var tRegister: T { return stack.count > 3 ? stack[3] : 0.convert() }
    
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
        return [T](count: 4, repeatedValue: 0.convert())
    }
}

// MARK: Operators
prefix operator √ {}
prefix func √ <T: NumberConvertible> (number: T) -> T {
    let x: Double = number.convert()
    return sqrt(x).convert()
}

infix operator ** { associativity left precedence 170 }
func ** <T: NumberConvertible> (lhs: T, rhs: T) -> T {
    let left: Double = lhs.convert()
    let right: Double = lhs.convert()
    return pow(left, right).convert()
}
