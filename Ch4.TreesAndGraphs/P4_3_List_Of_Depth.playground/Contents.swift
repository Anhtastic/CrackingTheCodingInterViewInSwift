//: Playground - noun: a place where people can play

import UIKit

// List of Depths: Given a binary tree, design an algorithm which creates a linked list of all the nodes at each depth (e.g., if you have a tree with depth D, you 'll have D linked lists).

class Node<T> {
    var value: T
    var next: Node?
    var left: Node?
    var right: Node?
    
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
    
    func append(value: T) {
        let newNode = Node(value: value)
        if let last = last {
            last.next = newNode
        } else {
            head = newNode
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
    // Solution 1: Breadth first search.
    func createBFSLevelsLinkedLists(root: Node<T>?) -> [LinkedList<T>]? {
        if root == nil { return nil }
        var result = [LinkedList<T>]()
        
        //  Similar to problem 2, we will implement using a stack because the cost of removing last is much cheaper than removing from the front by using a queue. Thus we will need to create a temporary stack call newStack to hold all the new elements and set it equal to the currentStack.
        var currentStack = [root]
        while !currentStack.isEmpty {
            let newLinkedList = LinkedList<T>()
            var newStack = [Node<T>]()
            for node in currentStack {
                newLinkedList.append(value: node!.value)
                if let left = node?.left {
                    newStack.append(left)
                }
                if let right = node?.right {
                    newStack.append(right)
                }
                currentStack.removeLast()
            }
            currentStack = newStack
            result.append(newLinkedList)
        }
        return result
    }
    
    // Solution 2: Depth First Search.
    private func createDFSLevelsLinkedListsHelper(root: Node<T>?, level: Int, results: inout [LinkedList<T>]) {
        
        if root == nil { return }
        if results.count == level {
            let newList = LinkedList<T>()
            newList.append(value: root!.value)
            results.append(newList)
        } else {
            let currentList = results[level]
            currentList.append(value: root!.value)
        }
        
        createDFSLevelsLinkedListsHelper(root: root?.left, level: level + 1, results: &results)
        createDFSLevelsLinkedListsHelper(root: root?.right, level: level + 1, results: &results)
    }
    
    func createDFSLevelsLinkedLists(root: Node<T>?) -> [LinkedList<T>]? {
        if root == nil { return nil }
        var results = [LinkedList<T>]()
        createDFSLevelsLinkedListsHelper(root: root, level: 0, results: &results)
        return results
    }
    
}

let tree = Node<Int>(value: 1)
tree.left = Node(value: 2)
tree.right = Node(value: 3)
tree.left?.left = Node(value: 4)
tree.left?.right = Node(value: 5)
tree.right?.left = Node(value: 6)
tree.right?.right = Node(value: 7)

let resultBFS = Result<Int>()
if let listsBFS = resultBFS.createBFSLevelsLinkedLists(root: tree) {
    print(listsBFS)
}

let resultDFS = Result<Int>()
if let listsDFS = resultDFS.createDFSLevelsLinkedLists(root: tree) {
    print(listsDFS)
}





