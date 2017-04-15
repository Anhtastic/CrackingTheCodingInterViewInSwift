//: Playground - noun: a place where people can play

import UIKit

//  Stack of Plates: Imagine a (literal) stack of plates. If the stack gets too high, it might topple. Therefore, in real life, we would likely start a new stack when the previous stack exceeds some threshold. Implement a data structure SetOfStacks that mimics this. SetOfStacks should be composed of several stacks and should create a new stack once the previous one exceeds capacity. SetOfStacks.push() and SetOfStacks.pop() should behave identically to a single stack (that is, pop() should return the same values as it would if there were just a single stack).

//  FOLLOW UP
//  Implement a function popAt (int index) which performs a pop operation on a specific substack.


// 2 SOLUTIONS ARE IMPLEMENTED HERE. 

// Solution 1 is implemented with arrays,
// thus when we have to popAt(index) and rotate the stacks around, we are using 
// removeFirst() method which is inefficient.

// Solution 2 is implemented with pointer nodes, think like linked list. when
// we remove first (also known as bottom of stack), it's much more efficient.


// One other major difference b/w soln 1 and 2 is in the popAt(index) method. When we refer
// the index in soln 1, we are referring to the actualy index of the whole array.
// For instance if we have 3 stacks with capacity 3 with the following stacks: 
// [[1,2,3], [4,5,6], [7,8,9]], element 9 is at index 8, so we can basicaly remove at any index.
// As for soln 2, we are popping at substack, not actually indices. So in the above scenario, 
// we can only pop the last element in stack 1, 2, 3. 

// Obviously soln 2 is more of the definition of stack popping... but 
// I wanted to try to pop at any element just for fun because I'm popping! :)


enum ErrorHandling {
    case IndexOutOfRange
    
    func handleError(error: ErrorHandling) {
        switch error {
        case .IndexOutOfRange:
            print("Index out of range")
        }
    }
}

//  SOLUTION 1
class Stack {
    var size = 0
    var capacity: Int
    var values = [Int]()
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func push(value: Int) {
        size += 1
        values.append(value)
    }
    
    func pop() -> Int? {
        if values.isEmpty { return nil }
        size -= 1
        return values.removeLast()
    }
    
    func isFull() -> Bool {
        return capacity == size
    }
    
    func isEmpty() -> Bool {
        return size == 0
    }
    
    func popAt(index: Int) -> Int? {
        guard index >= 0 && index < capacity else { return nil }
        size -= 1
        return values.remove(at: index)
    }
    
    func removeFirst() -> Int? {
        guard !values.isEmpty else { return nil }
        return values.removeFirst()
    }

}

class SetOfStacks {
    
    var stacks = [Stack]()
    var capacity: Int
    let numberOfStacks = 3 // Set = 3 right? :p If not, I'll assume we are playing poker.
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func push(value: Int) {
        guard stacks.count <= numberOfStacks else {
            ErrorHandling.handleError(.IndexOutOfRange)
            return
        }
        
        let lastStack = stacks.last
        if lastStack != nil && !lastStack!.isFull() {
            lastStack?.push(value: value)
        } else {
            let newStack = Stack(capacity: capacity)
            newStack.push(value: value)
            stacks.append(newStack)
        }
    }
    
    func pop() -> Int? {
        let lastStack = stacks.last
        if lastStack == nil { return nil }
        
        let rval = lastStack?.pop()
        if lastStack!.isEmpty() { // get rid of this sucker since stack is now empty.
            stacks.removeLast()
        }
        return rval
    }
    
    
    func popAt(index: Int) -> Int? {
        if stacks.isEmpty { return nil }
        let stackIndex = index % capacity
        let stackNumber = index / stacks.count
        guard stackNumber < stacks.count else { return nil }
        let stack = stacks[stackNumber]
        let val = stack.popAt(index: stackIndex)
        
        for i in stackNumber  ..< stacks.count - 1 {
            if let elementNextStack = stacks[i + 1].removeFirst() {
                stacks[i].push(value: elementNextStack)
                stacks[i + 1].size -= 1
            }
        }
        if let last = stacks.last {
            if last.isEmpty() {
                stacks.removeLast()
            }
        }
        
        return val ?? nil
    }
}

let set = SetOfStacks(capacity: 3)
set.push(value: 1)
set.push(value: 2)
set.push(value: 3)
set.push(value: 4)
set.push(value: 5)
set.push(value: 6)
set.push(value: 7)
set.push(value: 8)
set.push(value: 9)
set.popAt(index: 6)
for stack in set.stacks {
    print(stack.values)
}
set.pop()
set.pop()
set.pop()
set.pop()
set.pop()
set.pop()
set.push(value: 10)
for stack in set.stacks {
    print(stack.values)
}



//  SOLUTION 2
class Node {
    var above: Node?
    var below: Node?
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

class Stack2 {
    private var capacity: Int
    var top: Node?
    var bottom: Node?
    var size = 0
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    var isFull: Bool {
        return capacity == size
    }
    
    func join(above: Node?, below: Node?) {
        if below != nil {
            below?.above = above
        }
        if above != nil {
            above?.below = below
        }
    }
    
    func push(value: Int) -> Bool {
        if size >= capacity { return true }
        size += 1
        let n = Node(value: value)
        if size == 1 { bottom = n }
        join(above: n, below: top)
        top = n
        return true
    }
    
    func pop() -> Int? {
        if top == nil { return nil }
        let rval = top
        top = top?.below
        top?.above = nil
        size -= 1
        return rval?.value
    }
    
    func isEmpty() -> Bool {
        return size == 0
    }
    
    func removeBottom() -> Int? {
        let b = bottom
        bottom = bottom?.above
        if bottom != nil { bottom?.below = nil }
        size -= 1
        return b?.value
    }
    
    
}

class SetOfStacks2: CustomStringConvertible {
    
    var stacks = [Stack2]()
    var capacity: Int
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func getLastStack() -> Stack2? {
        if stacks.count == 0 { return nil }
        return stacks[stacks.count - 1]
    }
    
    func push(value: Int) {
        let lastStack = getLastStack() ?? nil
        if lastStack != nil && !lastStack!.isFull {
            lastStack?.push(value: value)
        } else {
            let newStack = Stack2(capacity: capacity)
            newStack.push(value: value)
            stacks.append(newStack)
        }
    }
    
    func pop() -> Int? {
        let lastStack = getLastStack()
        if lastStack == nil { return nil }
        let rval = lastStack!.pop()
        if lastStack?.size == 0 {
            stacks.removeLast()
        }
        return rval
    }

    
    func leftShift(index: Int, removeTop: Bool) -> Int? {
        guard index < stacks.count else {
            ErrorHandling.handleError(.IndexOutOfRange)
            return nil
        }
        let stack = stacks[index]
        var removedItem: Int?
        if removeTop {
            removedItem = stack.pop()
        } else {
            removedItem = stack.removeBottom()
        }
        if stack.isEmpty() {
            stacks.remove(at: index)
        } else if stacks.count > index + 1 {
            let value = leftShift(index: index + 1, removeTop: false)!
            stack.push(value: value)
        }
        return removedItem
    }
    
    func popAt(index: Int) -> Int? {
        return leftShift(index: index, removeTop: true)
    }
    
    var description: String {
        var rval = "["
        for stack in stacks {
            var bottom = stack.bottom
            rval += "["
            while bottom != nil {
                rval += "\(bottom!.value), "
                bottom = bottom?.above
            }
            rval += "]  "
        }
        return rval + "]"
    }
    
}
let set2 = SetOfStacks2(capacity: 3)
set2.push(value: 1)
set2.push(value: 2)
set2.push(value: 3)
set2.push(value: 4)
set2.push(value: 5)
set2.push(value: 6)
set2.push(value: 7)
set2.push(value: 8)
set2.push(value: 9)
set2.popAt(index: 1)
set2.popAt(index: 3)
print(set2)




