//: Playground - noun: a place where people can play

import UIKit

// Validate BST: Implement a function to check if a binary tree is a binary search tree.

class Node: CustomStringConvertible {
    var left: Node?
    var right: Node?
    
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
    
    // Solution 1: In Order Traversal -> Left, Node, Right
    // Assumption: No Duplicates allowed in tree.
    private func isBSTHelper(root: Node?, currentValue: inout Int?) -> Bool {
        if root == nil { return true }
        if !isBSTHelper(root: root?.left, currentValue: &currentValue) {
            return false
        }
        
        if currentValue == nil {
            currentValue = root!.value
        } else if currentValue! >= root!.value {
            return false
        } else {
            currentValue = root!.value
        }
        if !isBSTHelper(root: root?.right, currentValue: &currentValue) {
            return false
        }
        
        return true
    }
    
    func isBSTInOrderTraversal(root: Node?) -> Bool {
        var currentValue: Int?
        return isBSTHelper(root: root, currentValue: &currentValue)
    }
    
    // Solution 2: Min/Max Solution: Duplicates allowed! :)
    private func isBSTMinMaxHelper(root: Node?, min: Int?, max: Int?) -> Bool {
        
        if root == nil { return true }
        
        if max != nil && root!.value > max! || min != nil && root!.value <= min! {
            return false
        }
        
        if !isBSTMinMaxHelper(root: root?.left, min: min, max: root!.value) || !isBSTMinMaxHelper(root: root?.right, min: root!.value, max: max) {
            return false
        }
        
        return true
    }
    
    func isBSTMinMax(root: Node?) -> Bool {
        return isBSTMinMaxHelper(root: root, min: nil, max: nil)
    }
}

let tree = Node(value: 4)
tree.left = Node(value: 2)
tree.left?.left = Node(value: 1)
tree.left?.right = Node(value: 3)
tree.right = Node(value: 6)
tree.right?.left = Node(value: 5)
tree.right?.right = Node(value: 7)
print("tree: \(tree)")
let result = Result()
result.isBSTInOrderTraversal(root: tree)
result.isBSTMinMax(root: tree)

let tree2 = Node(value: 4)
tree2.left = Node(value: 2)
tree2.left?.left = Node(value: 1)
tree2.left?.right = Node(value: 3)
tree2.right = Node(value: 6)
tree2.right?.left = Node(value: 5)
tree2.right?.right = Node(value: 2)
print("tree 2: \(tree2)")
result.isBSTInOrderTraversal(root: tree2)
result.isBSTMinMax(root: tree2)


result.isBSTInOrderTraversal(root: nil)
result.isBSTMinMax(root: nil)


































