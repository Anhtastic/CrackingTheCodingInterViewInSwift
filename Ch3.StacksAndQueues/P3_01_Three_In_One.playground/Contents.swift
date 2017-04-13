//: Playground - noun: a place where people can play

import UIKit

//  Three in One: Describe how you could use a single array to implement three stacks.

enum ErrorHandling: Error {
    case stackIsFull
    case stackIsEmpty
    case threeStacksOnly
    case unknownErrors
}

class FixedMultiStack<T>: CustomStringConvertible {
    private var numberOfStacks = 3
    private var stackSize = Int()
    private var values: [T]
    private var sizes = [Int]()
    private var type: T
    
    init(stackSize: Int, type: T) {
        self.stackSize = stackSize
        self.type = type
        values = [T](repeatElement(type, count: stackSize * numberOfStacks))
        sizes = [Int](repeatElement(Int(), count: numberOfStacks))
    }
    
    private func handleError(error: ErrorHandling) {
        let defaultMessage = "Something is wrong, got to investigate noob!"
        switch error {
        case .stackIsFull:
            print("Stack is full, can't add any more noob!")
        case .stackIsEmpty:
            print("Stack is empty noob!")
        case .threeStacksOnly:
            print("Foo, how you going to build 3 into one if you trying to access a stack that's non existent?")
        default:
            print(defaultMessage)
        }
    }
    
    private func isEmpty(stackNum: Int) -> Bool {
        return sizes[stackNum] == 0
    }
    private func isFull(stackNum: Int) -> Bool {
        return sizes[stackNum] == stackSize
    }
    
    private func indexOfTop(stackNum : Int) -> Int {
        let offSet = stackNum * stackSize
        let size = sizes[stackNum]
        return offSet + size - 1
    }
    
    func push(stackNum: Int, value: T) {
        guard stackNum <= 3 && stackNum >= 1 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return
        }
    
        if isFull(stackNum: stackNum - 1) {
            let error = ErrorHandling.stackIsFull
            handleError(error: error)
            return
        }
        sizes[stackNum - 1] += 1
        values[indexOfTop(stackNum: stackNum - 1)] = value
    }
    
    
    func pop(stackNum: Int) -> T? {
        
        guard stackNum <= 3 && stackNum >= 1 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return nil
        }
        
        if isEmpty(stackNum: stackNum - 1) {
            let error = ErrorHandling.stackIsEmpty
            handleError(error: error)
            return type
        }
        
        let topIndex = indexOfTop(stackNum: stackNum - 1)
        let value = values[topIndex]
        values[topIndex] = type
        sizes[stackNum - 1] -= 1
        return value 
    }
    
    func peek(stackNum: Int) -> T? {
        
        guard stackNum <= 3 && stackNum >= 0 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return type
        }
        
        if isEmpty(stackNum: stackNum - 1) {
            let error = ErrorHandling.stackIsEmpty
            handleError(error: error)
            return type
        }
        return values[indexOfTop(stackNum: stackNum - 1)]
    }
    
    var description: String {
        var rval = "["
        for i in values.indices {
            if i == values.count - 1 {
                rval += String(describing: values[i])
            } else {
                rval += String(describing: values[i]) + ", "
            }
        }
        rval += "]"
        return rval
    }
    
}


// Solution 2

class MultiStack: CustomStringConvertible {
    
    class StackInfo {
        var start: Int
        var size = 0
        var capacity: Int
        var multiStack: MultiStack
        init(start: Int, capacity: Int, multiStack: MultiStack) {
            self.start = start
            self.capacity = capacity
            self.multiStack = multiStack
        }
        
        func isWithinStackCapacity(index: Int) -> Bool {
            if index < 0 || index > multiStack.values.count {
                return false
            }
            
            let contiguousIndex = index < start ? index + multiStack.values.count : index
            let end = start + capacity
            return start <= contiguousIndex && contiguousIndex < end
        }
        
        func lastCapacityIndex() -> Int {
            return multiStack.adjustIndex(index: start + capacity - 1)
        }
        
        func lastElementIndex() -> Int  {
            return multiStack.adjustIndex(index: start + size - 1)
        }
        
        func isFull() -> Bool { return size == capacity }
        func isEmpty() -> Bool { return size == 0 }
        func getCapacity() -> Int { return capacity }
        func getSize() -> Int { return size }
    }
    
    private var stacks: [StackInfo?]
    private var values = [Int]()
    
    init(numberOfStacks: Int, defaultSize: Int) {
        stacks = [StackInfo?](repeatElement(nil, count: numberOfStacks))
        for i in 0 ..< numberOfStacks {
            stacks[i] = StackInfo(start: defaultSize * i, capacity: defaultSize, multiStack: self)
        }
        values = [Int](repeatElement(Int(), count: numberOfStacks * defaultSize))
    }
    
    
    private func handleError(error: ErrorHandling) {
        let defaultMessage = "Something is wrong, got to investigate noob!"
        switch error {
        case .stackIsFull:
            print("Stack is full, can't add any more noob!")
        case .stackIsEmpty:
            print("Stack is empty noob!")
        case .threeStacksOnly:
            print("Foo, how you going to build 3 into one if you trying to access a stack that's non existent?")
        default:
            print(defaultMessage)
        }
    }
    
    private func numberOfElements() -> Int {
        var size = 0
        for stack in stacks {
            if let stack = stack {
                size += stack.size
            }
        }
        return size
    }
    
    private func allStacksArefull() -> Bool {
        return numberOfElements() == values.count
    }
    
    private func adjustIndex(index: Int) -> Int {
        let max = values.count
        return ((index % max) + max) % max
    }
    
    private func nextIndex(index: Int) -> Int {
        return adjustIndex(index: index + 1)
    }
    
    private func prevIndex(index: Int) -> Int {
        return adjustIndex(index: index - 1)
    }
    
    private func shift(stackNum: Int) {
        print("/// Shifting \(stackNum)")
        
        let stack = stacks[stackNum]!
        if stack.size >= stack.capacity {
            let nextStack = (stackNum + 1) % stacks.count
            shift(stackNum: nextStack)
            stack.capacity += 1
        }
        
        var index = stack.lastCapacityIndex()
        while stack.isWithinStackCapacity(index: index) {
            values[index] = values[prevIndex(index: index)]
            index = prevIndex(index: index)
        }
        
        values[stack.start] = 0 // Clear item
        stack.start = nextIndex(index: stack.start) // move start
        stack.capacity -= 1 // Shrink capacity
    }
    
    private func expand(stackNum: Int) {
        print("/// Expanding stack \(stackNum)")
        guard stackNum >= 0 && stackNum <= 2 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return
        }
        
        shift(stackNum: (stackNum + 1) % stacks.count)
        stacks[stackNum]?.capacity += 1
    }
    
    func push(stackNum: Int, value: Int) {
        print("/// Adding value of \(value) into stack \(stackNum)")
        guard stackNum >= 0 && stackNum <= 2 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return
        }
        if allStacksArefull() {
            handleError(error: ErrorHandling.stackIsFull)
            return
        }
        
        let stack = stacks[stackNum]!
        if stack.isFull() {
            expand(stackNum: stackNum)
        }
        
        stack.size += 1
        values[stack.lastElementIndex()] = value
    }
    
    func pop(stackNum: Int) -> Int? {
        print("/// Removing last element from stack: \(stackNum)")
        guard stackNum >= 0 && stackNum <= 2 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return nil
        }
        
        let stack = stacks[stackNum]!
        if stack.isEmpty() {
            handleError(error: ErrorHandling.stackIsEmpty)
            return nil
        }
        
        let value = values[stack.lastElementIndex()]
        values[stack.lastElementIndex()] = 0 // Clear item
        stack.size -= 1
        return value
    }

    func peek(stackNum: Int) -> Int? {
        guard stackNum >= 0 && stackNum <= 2 else {
            handleError(error: ErrorHandling.threeStacksOnly)
            return nil
        }
        
        let stack = stacks[stackNum]!
        if stack.isEmpty() {
            handleError(error: ErrorHandling.stackIsEmpty)
            return nil
        }
        
        return values[stacks[stackNum]!.lastElementIndex()]
    }
    
    func getStacks() -> [MultiStack.StackInfo?] {
        return stacks
    }
    
    func getStackValues(stackNum: Int) -> [Int] {
        let stack = stacks[stackNum]!
        var items = [Int](repeatElement(Int(), count: stack.size))
        for i in 0 ..< items.count {
            items[i] = values[adjustIndex(index: stack.start + i)]
        }
        return items
    }
    
    var description: String {
        var rval = "["

        for i in values.indices {
            if i == values.count - 1 {
                rval += String(describing: values[i])
            } else {
                rval += String(describing: values[i]) + ", "
            }
        }
        rval += "]"
        return rval
    }
    
}



let example  = FixedMultiStack(stackSize: 3, type: Int())
example.push(stackNum: 1, value: 1)
example.push(stackNum: 1, value: 2)
example.push(stackNum: 1, value: 3)
example.push(stackNum: 2, value: 4)
example.push(stackNum: 2, value: 5)
example.push(stackNum: 2, value: 6)
example.push(stackNum: 3, value: 7)
example.push(stackNum: 3, value: 8)
example.push(stackNum: 3, value: 9)
example.push(stackNum: 3, value: 10)
example.pop(stackNum: 2)
example.pop(stackNum: 1)
example.peek(stackNum: 3)
print(example)

let example2 = FixedMultiStack(stackSize: 3, type: String())
example2.pop(stackNum: 0)
example2.push(stackNum: 4, value: "b")
example2.push(stackNum: 1, value: "a")
example2.peek(stackNum: 3)




// IMPORTANT: There's a bug in this code. If you push 9 items in one stack (stack 1, 1 to 9), then pop one item from stack 1 (stack 1, 1 to 8). Then add in an item in stack 2, the code will run infinitely. This is because the capacity of the stacks at this point are very fudgy. Edgy case overall.
let multiStackExample = MultiStack(numberOfStacks: 3, defaultSize: 3)
multiStackExample.push(stackNum: 1, value: 1)
multiStackExample.push(stackNum: 1, value: 2)
multiStackExample.push(stackNum: 1, value: 3)
multiStackExample.push(stackNum: 0, value: 4)
multiStackExample.push(stackNum: 0, value: 5)
multiStackExample.push(stackNum: 0, value: 6)
multiStackExample.push(stackNum: 2, value: 7)
multiStackExample.push(stackNum: 2, value: 8)
multiStackExample.push(stackNum: 2, value: 9)
multiStackExample.pop(stackNum: 1)
multiStackExample.push(stackNum: 2, value: 10)
multiStackExample.push(stackNum: 2, value: 100) // Out of room.
let stacks = multiStackExample.getStacks()
for i in 0 ..< stacks.count {
    let capacity = stacks[i]!.getCapacity()
    let size = stacks[i]!.getSize()
    print("stack \(i): capacity is \(capacity) and size is \(size)")
}
multiStackExample.getStackValues(stackNum: 0)
multiStackExample.getStackValues(stackNum: 1)
multiStackExample.getStackValues(stackNum: 2)








