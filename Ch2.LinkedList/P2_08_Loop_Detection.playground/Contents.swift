//: Playground - noun: a place where people can play

import UIKit

//  Loop Detection: Given a circular linked list, implement an algorithm that returns the node at the beginning of the loop.
//  DEFINITION
//  Circular linked list: A (corrupt) linked list in which a node's next pointer points to an earlier node, so as to make a loop in the linked list.
//  EXAMPLE
//  Input: A -> B -> C - > D -> E -> C [the same C as earlier)
//  Output: C

class Node<T> {
    var next: Node<T>?
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T> {
    var head: Node<T>?
    var last: Node<T>? {
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
    
    func insertValues(values: [T]) {
        for value in values {
            insert(value: value)
        }
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

class Result<T> {
    
    func findCircularNodeBeginning(list: LinkedList<T>) -> Node<T>? {
        
        var slowRunner = list.head
        var fastRunner = list.head
        
        while fastRunner != nil && fastRunner?.next != nil {
            slowRunner = slowRunner?.next
            fastRunner = fastRunner?.next?.next
            if slowRunner === fastRunner {
                slowRunner = list.head
                break
            }
        }
        
        if fastRunner == nil || fastRunner?.next == nil { return nil }
        
        while slowRunner !== fastRunner {
            slowRunner = slowRunner?.next
            fastRunner = fastRunner?.next
        }
        
        return slowRunner
    }
    
}

let list = LinkedList<String>()
list.insertValues(values: ["A", "B", "C", "D", "E"])
list.description
// We can't really get a string representation below because it'd run infinitely since it's a circular linked list :)
list.last?.next = list.head?.next?.next // Using the example from the problem.
let result = Result<String>()
result.findCircularNodeBeginning(list: list)?.value

let list2 = LinkedList<String>()
list2.insertValues(values: ["A", "B", "C", "D"])
result.findCircularNodeBeginning(list: list2)

















