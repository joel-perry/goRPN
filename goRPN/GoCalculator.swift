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
    var stack = [T]()
    
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
