//: Playground - noun: a place where people can play

import UIKit

//  Palindrome: Implement a function to check if a linked list is a palindrome.

class Node {
    
    var next: Node?
    var value: String
    
    init(value: String) {
        self.value = value
    }
}

class LinkedList: CustomStringConvertible {
    
    var head: Node?
    var last: Node? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        return node
    }
    
    func insert(value: String) {
        if let last = last {
            last.next = Node(value: value)
        } else {
            head = Node(value: value)
        }
    }
    
    func insertValues(values: [String]) {
        for value in values {
            insert(value: value)
        }
    }
    
    var count: Int {
        var count = 0
        var node = head
        while node != nil {
            count += 1
            node = node?.next
        }
        return count
    }
    
    var isEven: Bool {
        return count % 2 == 0
    }
    
    var description: String {
        var rval = "["
        var node = head
        while node != nil {
            rval += "\(node!.value) -> "
            node = node?.next
        }
        
        return rval + "]"
    }
    
}

class Result {
    
    // Solution 1: Reverse the list and then compare
    private func cloneAndReverse(list: LinkedList) -> LinkedList {
        var head: Node?
        var node = list.head
        
        while node != nil {
            let n = Node(value: node!.value)
            n.next = head
            head = n
            node = node?.next
        }
        
        let result = LinkedList()
        result.head = head
        return result
    }
    
    
    func isPalindromeReverse(list: LinkedList) -> Bool {
        let reverse = cloneAndReverse(list: list)
        var node = list.head
        var reverseNode = reverse.head
        
        while node != nil {
            if node?.value != reverseNode?.value {
                return false
            }
            node = node?.next
            reverseNode = reverseNode?.next
        }
        return true
    }
    
    // Solution 2: Iterative Approach
    // With LinkedList count
    func isPalindromeIterativeCount(list: LinkedList) -> Bool {
        
        var stack = [String]()
        var node = list.head
        let count = list.count
        var moveToMiddleCount = list.isEven ? (count/2) : (count/2) + 1
        
        while moveToMiddleCount > 0 {
            stack.append(node!.value)
            node = node?.next
            moveToMiddleCount -= 1
        }

        if !list.isEven {
            stack.popLast() // Remove the middle odd ball if the list is odd before comparing.
        }

        while node != nil {
            if node!.value != stack.popLast() {
                return false
            }
            node = node?.next
        }
        
        return true
    }
    
    // Iterative approach with no knowledge of the count of the list.
    func isPalindromeIterativeNoCount(list: LinkedList) -> Bool {
        
        var slowRunner = list.head
        var doubleSlowRunner = list.head
        var stack = [String]()
        while doubleSlowRunner != nil && doubleSlowRunner?.next != nil {
            stack.append(slowRunner!.value)
            slowRunner = slowRunner?.next
            doubleSlowRunner = doubleSlowRunner?.next?.next
        }
        
        if doubleSlowRunner != nil { // If odd, skip mid element.
            slowRunner = slowRunner?.next
        }
        
        while slowRunner != nil {
            if slowRunner!.value != stack.popLast() {
                return false
            }
            slowRunner = slowRunner?.next
        }
        return true
    }
    
    // Solution 3: Recursion
    private func isPalindromeRecurse(head: Node?, length: Int) -> ResultWrapper {
        if head == nil || length == 0 {
            return ResultWrapper(node: head, result: true)
        } else if length == 1 { // Odd number of nodes
            return ResultWrapper(node: head?.next, result: true)
        }
        
        // Recurse on sublist
        let result = isPalindromeRecurse(head: head?.next, length: length - 2)
        
        if !result.result || result.node == nil {
            return result
        }
        
        result.result = head?.value == result.node?.value
        
        result.node = result.node?.next
        
        return result
    }
    
    func isPalindromeRecurse(list: LinkedList) -> Bool {
        let resultWrapper = isPalindromeRecurse(head: list.head, length: list.count)
        return resultWrapper.result
    }
    
}

class ResultWrapper { // For soln 3
    var node: Node?
    var result: Bool
    
    init(node: Node?, result: Bool) {
        self.node = node
        self.result = result
    }
}

let list = LinkedList()
list.insertValues(values: ["A", "B", "C", "D", "C", "B", "A"])
let result = Result()
result.isPalindromeReverse(list: list)
result.isPalindromeIterativeCount(list: list)
result.isPalindromeIterativeNoCount(list: list)
result.isPalindromeRecurse(list: list)






































