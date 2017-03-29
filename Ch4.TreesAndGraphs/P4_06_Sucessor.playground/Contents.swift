//: Playground - noun: a place where people can play

import UIKit


// Successor: Write an algorithm to find the "next" node (i.e., in-order successor) of a given node in a binary search tree. You may assume that each node has a link to its parent.

class Node: CustomStringConvertible {
    var left: Node?
    var right: Node?
    var parent: Node?
    
    var value: Int
    init(value: Int) {
        self.value = value
    }
    
    var description: String {
        var rval = ""
        if let left = left {
            rval += "(\(left.description)) <-"
        }
        rval += String(describing: value)
        if let right = right {
            rval += "-> (\(right.description))"
        }
        return rval
    }
}

class Result {
    
    private func findMinimumNode(node: Node?) -> Node? {
        if node == nil { return nil }
        var node = node
        
        while node?.left != nil {
            node = node?.left
        }
        return node
    }
    
    func findSucessor(node: Node?) -> Node? {
        if node == nil { return nil }
        
        if node?.right != nil {
            return findMinimumNode(node: node?.right)
        } else {
            var parent = node?.parent
            var current = node
            while parent?.left !== current {
                current = parent
                parent = parent?.parent
            }
            return parent
        }
    }
}


let tree = Node(value: 4)
tree.left = Node(value: 2)
tree.left?.parent = tree
tree.left?.left = Node(value: 1)
tree.left?.left?.parent = tree.left
tree.left?.right = Node(value: 3)
tree.left?.right?.parent = tree.left
tree.right = Node(value: 6)
tree.right?.left = Node(value: 5)
tree.right?.left?.parent = tree.right
tree.right?.right = Node(value: 7)
tree.right?.right?.parent = tree.right
print(tree)

let result = Result()
result.findSucessor(node: tree.right?.right) // Node 7
result.findSucessor(node: tree) // Root Node 4
result.findSucessor(node: tree.left?.right) // Node 3: No Right


let tree2 = Node(value: 4)
tree2.left = Node(value: 2)
tree2.left?.parent = tree2
tree2.left?.left = Node(value: 1)
tree2.left?.left?.parent = tree2.left
print(tree2)
result.findSucessor(node: tree2.left) // Node 2




