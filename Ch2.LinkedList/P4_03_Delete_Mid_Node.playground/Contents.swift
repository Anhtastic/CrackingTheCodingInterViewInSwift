//: Playground - noun: a place where people can play

import UIKit

//  Delete Middle Node: Implement an algorithm to delete a node in the middle (Le., any node but the first and last node, not necessarily the exact middle) of a singly linked list, given only access to that node.
// EXAMPLE
// Input: the node c from the linked list a -> b -> c -> d -> e -> f
// Result: nothing is returned, but the new linked list looks like
// a -> b -> d -> e -> f


class Node<T> {
    var next: Node<T>?
    var value: T
    
    init(value: T) {
        self.value = value
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
    
    private func insertNode(node: Node<T>?) {
        if let last = last {
            last.next = node
        } else {
            head = node
        }
    }
    
    func insertNodes(nodes: [Node<T>?]) {
        for i in 0 ..< nodes.count {
            insertNode(node: nodes[i])
        }
    }
    
    func deleteMidNode(node: Node<T>?) {
        if node == nil || node?.next == nil { return }
        if let next = node?.next {
            node?.value = next.value
        }
        node?.next = node?.next?.next
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
let nodeA = Node(value: "A")
let nodeB = Node(value: "B")
let nodeC = Node(value: "C")
let nodeD = Node(value: "D")
let nodeE = Node(value: "E")
let nodeF = Node(value: "F")
list.insertNodes(nodes: [nodeA, nodeB, nodeC, nodeD, nodeE, nodeF])
list.deleteMidNode(node: nodeC)
list.deleteMidNode(node: nodeB)
list.deleteMidNode(node: nodeF)







