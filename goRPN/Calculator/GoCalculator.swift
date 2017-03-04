//
//  GoCalculator.swift
//  goRPN
//
//  Created by Joel Perry on 10/10/15.
//  Copyright (c) Joel Perry. All rights reserved.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.
//

import Foundation

// MARK: - NumberConvertible
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

// MARK: - StackOperation
enum StackOperation<T> {
    case push(T)
    case infix((_ lhs: T, _ rhs: T) -> T)
    case prefix((_ value: T) -> T)
}

// MARK: - GoCalculator
struct GoCalculator<T: NumberConvertible> {
    fileprivate var stack: [T] = []
    var xRegister: T { return stack.last ?? 0.convert() }
    var yRegister: T { return stack.dropLast().last ?? 0.convert() }
    var zRegister: T { return stack.dropLast(2).last ?? 0.convert() }
    var tRegister: T { return stack.dropLast(3).last ?? 0.convert() }
    
    mutating func loadStack() {
        if let savedStack = UserDefaults.standard.object(forKey: "stack") as? [T] {
            stack = savedStack
        }
    }
    
    func saveStack() {
        UserDefaults.standard.set(stack, forKey: "stack")
    }
    
    mutating func clearStack() {
        stack.removeAll()
    }
    
    mutating func performOperation(_ operation: StackOperation<T>) {
        switch operation {
        case .push(let value):
            stack.append(value)
            
        case .infix(let op):
            guard stack.count > 1 else { return }
            let rhs = stack.removeLast()
            let lhs = stack.removeLast()
            stack.append(op(lhs, rhs))
            
        case .prefix(let op):
            guard stack.count > 0 else { return }
            stack.append(op(stack.removeLast()))
        }
    }
}

// MARK: - Operators
prefix operator √
prefix func √ <T: NumberConvertible> (value: T) -> T {
    let x: Double = value.convert()
    return sqrt(x).convert()
}

infix operator **: ExponentiativePrecedence
precedencegroup ExponentiativePrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
}
func ** <T: NumberConvertible> (lhs: T, rhs: T) -> T {
    let left: Double = lhs.convert()
    let right: Double = rhs.convert()
    return pow(left, right).convert()
}
