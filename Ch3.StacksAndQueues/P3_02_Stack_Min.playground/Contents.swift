//: Playground - noun: a place where people can play

import UIKit

//  Stack Min: How would you design a stack which, in addition to push and pop, has a function min which returns the minimum element? Push, pop and min should all operate in 0(1) time.


class Stack<T: Comparable>: CustomStringConvertible {
    
    var stacks = [T]()
    var minStacks = [T]()
    
    func push(value: T) {
        stacks.append(value)
        if minStacks.isEmpty {
            minStacks.append(value)
        } else if minStacks.last! >= value {
            minStacks.append(value)
        }
    }
    
    func pop() -> T? {
        if stacks.isEmpty { return nil }
        let remove = stacks.removeLast()
        if remove == minStacks.last {
            minStacks.removeLast()
        }
        return remove
    }
    
    func min() -> T? {
        return minStacks.last ?? nil
    }
    
    var description: String {
        var rval = ""
        rval += "Stack: ["
        
        for value in stacks {
            rval += "\(value), "
        }
        
        rval += "], Min stack: ["
        
        for currentMin in minStacks {
            rval += "\(currentMin), "
        }
        
        return rval + "]"
    }

}

let stack = Stack<Int>()
stack.pop()
stack.push(value: 5)
stack.push(value: 6)
stack.push(value: 3)
stack.push(value: 1)
stack.push(value: 1)
stack.push(value: 8)
stack.min()
stack.pop()
stack.min()
print(stack)
stack.pop()
stack.min()
print(stack)
stack.pop()
stack.min()
print(stack)
stack.pop()
stack.min()
print(stack)






























