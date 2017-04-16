//: Playground - noun: a place where people can play

import UIKit

// Queue via Stacks: Implement a MyQueue class which implements a queue using two stacks.

class Stack<T> {
    
    var values = [T]()
    
    func push(value: T) {
        values.append(value)
    }
    
    func pop() -> T? {
        if values.isEmpty { return nil }
        return values.removeLast()
    }
    
    func isEmpty() -> Bool {
        return values.isEmpty
    }
    
    
}

class MyQueue<T>: CustomStringConvertible {
    
    var stackOne = Stack<T>()
    var stackTwo = Stack<T>()
    
    func push(value: T) {
        stackOne.push(value: value)
    }
    
    func pop() -> T? {
        if stackTwo.isEmpty() {
            while !stackOne.isEmpty() {
                if let pushS1ToS2Value = stackOne.pop() {
                    stackTwo.push(value: pushS1ToS2Value)
                }
            }
            return stackTwo.pop()
        } else {
            return stackTwo.pop()
        }
    }
    
    func peek() -> T? {
        if !stackTwo.isEmpty() {
            return stackTwo.values.last
        } else {
            return stackOne.values.first
        }
    }
    
    var description: String {
        var rval = "["
        
        for value in stackTwo.values.reversed() {
            rval += String("\(value), ")
        }
        
        for value in stackOne.values {
            rval += String("\(value), ")
        }
        
        return rval + "]"
    }
    
}


let queue = MyQueue<String>()
queue.pop()
queue.push(value: "1")
queue.push(value: "2")
queue.push(value: "3")
queue.push(value: "4")
queue.peek()
queue.pop()
queue
queue.push(value: "5")
queue.push(value: "6")
queue.peek()
queue.pop()
queue
queue.peek()
queue.pop()
queue
queue.peek()
queue.pop()
queue
queue.peek()
queue.pop()
queue
queue.peek()
queue.pop()
queue
queue.peek()
queue.pop()






