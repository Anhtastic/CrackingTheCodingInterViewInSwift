//: Playground - noun: a place where people can play

import UIKit

//  Sort Stack: Write a program to sort a stack such that the smallest items are on the top. You can use an additional temporary stack, but you may not copy the elements into any other data structure (such as an array). The stack supports the following operations: push, pop, peek, and isEmpty.

class Stack: CustomStringConvertible {
    
    var values = [Int]()
    
    func push(value: Int) {
        values.append(value)
    }
    
    func pop() -> Int? {
        if values.isEmpty { return nil }
        return values.removeLast()
    }
    
    func peek() -> Int? {
        return values.last
    }
    
    func isEmpty() -> Bool {
        return values.isEmpty
    }
    
    var description: String {
        
        var rval = "["
        
        for value in values {
            rval += "\(value), "
        }
        
        return rval + "]"
    }
}

class Result {
    
    func sortStackIteratively(stack: Stack) -> Stack {
        let sortedStack = Stack()
        
        while !stack.isEmpty() {
            let temp = stack.pop()!
            while !sortedStack.isEmpty() && temp > sortedStack.peek()! {
                stack.push(value: sortedStack.pop()!)
            }
            sortedStack.push(value: temp)
        }
        return sortedStack
    }
    
    
    private func sortStackRecursively(stack: Stack, sortedStack: Stack) -> Stack {
        if stack.isEmpty() { return stack }
        let temp = stack.pop()!
        
        if let peek = sortedStack.peek() {
            if temp <= peek {
                sortedStack.push(value: temp)
                sortStackRecursively(stack: stack, sortedStack: sortedStack)
            } else {
                let sortedPop = sortedStack.pop()!
                stack.push(value: sortedPop)
                stack.push(value: temp)
                sortStackRecursively(stack: stack, sortedStack: sortedStack)
            }
        } else {
            sortedStack.push(value: temp)
            sortStackRecursively(stack: stack, sortedStack: sortedStack)
        }
        return sortedStack
    }
    
    func sortStackRecursively(stack: Stack) -> Stack {
        let sortStack = Stack()
        return sortStackRecursively(stack: stack, sortedStack: sortStack)
    }
}

let result = Result()
let stack = Stack()
stack.push(value: 5)
stack.push(value: 2)
stack.push(value: 3)
stack.push(value: 1)
stack.push(value: 4)

result.sortStackIteratively(stack: stack)


let stack2 = Stack()
stack2.push(value: 5)
stack2.push(value: 2)
stack2.push(value: 3)
stack2.push(value: 1)
stack2.push(value: 4)
result.sortStackRecursively(stack: stack2)





























