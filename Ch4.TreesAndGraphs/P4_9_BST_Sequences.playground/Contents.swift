//: Playground - noun: a place where people can play

import UIKit

// BST Sequences: A binary search tree was created by traversing through an array from left to right and inserting each element. Given a binary search tree with distinct elements, print all possible arrays that could have led to this tree.
// Example 1 <- 2 -> 3
// Output: [[2,1,3], [2,3,1]]
class Node {
    
    var left: Node?
    var right: Node?
    var next: Node?
    var previous: Node?
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

// We choose to create a double linked list here because in weave function when we have to remove and add in the front of a list, it's much more cheaper than removing/adding back in an array. O(1) for linked list vs O(n) for array.
class LinkedList: CustomStringConvertible {
    
     private var head: Node?
    
     private var last: Node? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        return node
    }
    
    var isEmpty: Bool {
        return head == nil
    }
    
    func insert(value: Int) {
        let newNode = Node(value: value)
        if let last = last {
            newNode.previous = last
            last.next = newNode
        } else {
            head = newNode
        }
    }
    
    func removeFirst() -> Int? {
        let newHead = head?.next
        let currentReturnValue = head?.value
        head = newHead
        return currentReturnValue ?? nil
    }
    
    func removeLast() {
        let prev = last?.previous
        let next = last?.next
        prev?.next = next
    }
    
    func insertToFront(value: Int) {
        let currentHead = head
        let newHead = Node(value: value)
        newHead.next = currentHead
        currentHead?.previous = newHead
        head = newHead
    }
    
    func combineLists(list: LinkedList) {
        let newList = LinkedList()
        newList.head = list.head
        if let last = last {
            newList.head?.previous = last
            last.next = newList.head
        } else {
            head = newList.head
        }
    }
    
    func cloneList() -> LinkedList {
        let newList = LinkedList()
        var node = head
        while node != nil {
            newList.insert(value: node!.value)
            node = node?.next
        }
        return newList
    }
    public var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil { s += " -> " }
        }
        return s + "]"
    }
    
}


class Result {
    
     private func weaveLists(left: LinkedList, right: LinkedList, prefix: LinkedList, results: inout [LinkedList]) {
        if left.isEmpty || right.isEmpty {
            let clonePrefix = prefix.cloneList()
            clonePrefix.combineLists(list: left)
            clonePrefix.combineLists(list: right)
            results.append(clonePrefix)
            return
        }
        
        if let leftFrontValueRemoved = left.removeFirst() {
            prefix.insert(value: leftFrontValueRemoved)
            weaveLists(left: left, right: right, prefix: prefix, results: &results)
            prefix.removeLast()
            left.insertToFront(value: leftFrontValueRemoved)
        }
        
        if let rightFrontValueRemoved = right.removeFirst() {
            prefix.insert(value: rightFrontValueRemoved)
            weaveLists(left: left, right: right, prefix: prefix, results: &results)
            prefix.removeLast()
            right.insertToFront(value: rightFrontValueRemoved)
        }
    }
    
    func findSequences(root: Node?) -> [LinkedList] {
        var result = [LinkedList]()
        if root == nil {
            let newList = LinkedList()
            result.append(newList)
            return result
        }
        
        let leftSeq = findSequences(root: root?.left)
        let rightSeq = findSequences(root: root?.right)
        
        if let prefix = root?.value {
            let prefixList = LinkedList()
            prefixList.insert(value: prefix)
            for left in leftSeq {
                for right in rightSeq {
                    var weaved = [LinkedList]()
                    weaveLists(left: left, right: right, prefix: prefixList, results: &weaved)
                    result.append(contentsOf: weaved)
                }
            }
        }
        
        return result
    }
}

// Example 1 Test: 1 <- 2 -> 3
let treeExample = Node(value: 2)
treeExample.left = Node(value: 1)
treeExample.right = Node(value: 3)

// Example 2 Test: (2 <- 3 -> 4) <- 5 -> 7
let tree = Node(value: 5)
tree.left = Node(value: 3)
tree.left?.left = Node(value: 2)
tree.left?.right = Node(value: 4)
tree.right = Node(value: 7)

let result = Result()
print(result.findSequences(root: treeExample))
print(result.findSequences(root: tree))
































