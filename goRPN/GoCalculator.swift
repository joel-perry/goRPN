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
    case Prefix((value: T) -> T)
}

class GoCalculator<T: NumberConvertible> {
    // MARK: Public
    var xRegister: T { return stack.last ?? 0.convert() }
    var yRegister: T { return stack.dropLast().last ?? 0.convert() }
    var zRegister: T { return stack.dropLast(2).last ?? 0.convert() }
    var tRegister: T { return stack.dropLast(3).last ?? 0.convert() }
    
    func loadStack() {
        let savedStack = NSUserDefaults.standardUserDefaults().objectForKey("stack") as? [T]
        stack = savedStack ?? []
    }
    
    func saveStack() {
        NSUserDefaults.standardUserDefaults().setObject(stack as? AnyObject, forKey: "stack")
    }
    
    func clearStack() {
        stack = []
    }
    
    func performOperation(operation: StackOperation<T>) {
        switch operation {
        case .Push(let value):
            stack.append(value)
        case .Infix(let op):
            guard stack.count > 1 else { return }
            let right = stack.removeLast()
            let left = stack.removeLast()
            stack.append(op(lhs: left, rhs: right))
        case .Prefix(let op):
            guard stack.count > 0 else { return }
            stack.append(op(value: stack.removeLast()))
        }
    }
    
    // MARK: Private
    private var stack: [T] = []
}

// MARK: Operators
prefix operator √ {}
prefix func √ <T: NumberConvertible> (value: T) -> T {
    let x: Double = value.convert()
    return sqrt(x).convert()
}

infix operator ** { associativity left precedence 170 }
func ** <T: NumberConvertible> (lhs: T, rhs: T) -> T {
    let left: Double = lhs.convert()
    let right: Double = rhs.convert()
    return pow(left, right).convert()
}
