//: Playground - noun: a place where people can play

import UIKit

//  Return Kth to Last: Implement an algorithm to find the kth to last element of a singly linked list.

class Node<T> {
    var next: Node<T>?
    var value: T
    
    init(value: T) {
        self.value = value
    }
    
    var description: String {
        var node: Node<T>?
        node = self
        var rval = "["
        while node != nil {
            rval += "\(node!.value) -> "
            node = node?.next
        }
        return rval + "]"
    }
}

class LinkedList<T>: CustomStringConvertible {
    
    private var head: Node<T>?
    
    private var last: Node<T>? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        
        return node
    }
    
    func insert(value: T) {
        if let last = last {
            last.next = Node(value: value)
        } else {
            head = Node(value: value)
        }
    }
    
    // Recursive Soln 
    private func kthToLastRecursive(node: Node<T>?, k: Int, i: inout Int) -> Node<T>? {
        if node == nil { return nil }
        let nextNode = kthToLastRecursive(node: node?.next, k: k, i: &i)
        i += 1
        if i == k { return node }
        return nextNode
    }
    
    func kthToLastRecursive(k: Int) -> Node<T>? {
        var i = 0
        return kthToLastRecursive(node: head, k: k, i: &i)
    }
    
    
    // Iterative Soln
    func kthToLastIterative(k: Int) -> Node<T>? {
        var current = head
        var runner = head
        
        for _ in 0 ..< k {
            if runner == nil { return nil }
            runner = runner?.next
        }
        
        while runner != nil {
            current = current?.next
            runner = runner?.next
        }
        return current
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

let list = LinkedList<String>()
list.insert(value: "A")
list.insert(value: "B")
list.insert(value: "C")
list.insert(value: "D")
list.insert(value: "E")
list.insert(value: "F")

list.kthToLastRecursive(k: 0)?.description
list.kthToLastRecursive(k: 1)?.description
list.kthToLastRecursive(k: 2)?.description
list.kthToLastRecursive(k: 3)?.description
list.kthToLastRecursive(k: 4)?.description
list.kthToLastRecursive(k: 5)?.description
list.kthToLastRecursive(k: 6)?.description
list.kthToLastRecursive(k: 7)?.description

list.kthToLastIterative(k: 0)?.description
list.kthToLastIterative(k: 1)?.description
list.kthToLastIterative(k: 2)?.description
list.kthToLastIterative(k: 3)?.description
list.kthToLastIterative(k: 4)?.description
list.kthToLastIterative(k: 5)?.description
list.kthToLastIterative(k: 6)?.description
list.kthToLastIterative(k: 7)?.description


























