//: Playground - noun: a place where people can play

import UIKit

//  Random Node: You are implementing a binary search tree class from scratch, which, in addition to insert, find, and delete, has a method getRandomNode() which returns a random node from the tree. All nodes should be equally likely to be chosen. Design and implement an algorithm for getRandomNode, and explain how you would implement the rest of the methods.

class Node: CustomStringConvertible {
    var left: Node?
    var right: Node?
    var value: Int
    var size = 1
    
    init(value: Int) {
        self.value = value
    }
    
    func insert(value: Int) {
        if value <= self.value {
            if left == nil {
                left = Node(value: value)
            } else {
                left?.insert(value: value)
            }
        } else {
            if right == nil {
                right = Node(value: value)
            } else {
                right?.insert(value: value)
            }
        }
        size += 1
    }
    
    var description: String {
        var rval = ""
        if let left = left {
            rval += "(\(left.description)) <-"
        }
        rval += String(value)
        if let right = right {
            rval += "-> (\(right.description))"
        }
        return rval
    }
}

class Tree: CustomStringConvertible {
    
    var root: Node?
    func insert(value: Int) {
        if root == nil {
            root = Node(value: value)
        } else {
            root?.insert(value: value)
        }
    }
    
    private func getRandomNodeHelper(node: Node?, random: Int) -> Node? {
        let leftSize = node?.left?.size ?? 0
        if leftSize == random {
            return node
        } else if random < leftSize {
            return getRandomNodeHelper(node: node?.left, random: random)
        } else {
            return getRandomNodeHelper(node: node?.right, random: random - leftSize - 1)
        }
    }
    
    func getRandomNode() -> Node? {
        if root == nil {
            return nil
        } else {
            let random = Int(arc4random_uniform(UInt32(root!.size)))
            return getRandomNodeHelper(node: root, random: random)
        }
    }
    
    private func findHelper(node: Node?, value: Int) -> Node? {
        if node == nil {
            return nil
        } else if node!.value == value {
            return node
        } else if node!.value > value {
            return findHelper(node: node?.left, value: value)
        } else {
            return findHelper(node: node?.right, value: value)
        }
    }
    
    func find(value: Int) -> Node? {
        return findHelper(node: root, value: value)
    }
    
    private func findMinOnRightSubtree(node: Node?) -> Node? {
        if node == nil {
            return nil
        } else {
            var node = node
            while node?.left != nil {
                node = node?.left
            }
            return node
        }
    }
    
    private func delete(root: Node?, value: Int) -> Node? {
        if root == nil { return root }
        root?.size -= 1
        if value < root!.value {
            root?.left = delete(root: root?.left, value: value)
        } else if value > root!.value {
            root?.right = delete(root: root?.right, value: value)
        } else { // Found our node!
            // Scenario 1: leaf node: no left or right.
            if root?.left == nil && root?.right == nil {
                return root?.left // Can return either left or right since they're both nil
            } else if root?.left != nil && root?.right == nil { // Scenario 2: has left but no right node.
                return root?.right
            } else { // Scenario 3: there's a right leaf node
                let minNode = findMinOnRightSubtree(node: root?.right)
                root?.value = minNode!.value
                root?.right = delete(root: root?.right, value: root!.value)
            }
        }
        return root
    }
    
    func delete(value: Int) -> Node? {
        return delete(root: root, value: value)
    }
    
    var description: String {
        var rval = ""
        if let left = root?.left {
            rval += "(\(left.description)) <-"
        }
        if let root = root {
            rval += String(describing: root.value)
        }
        if let right = root?.right {
            rval += "-> (\(right.description))"
        }
        return rval
    }
    
}

let tree = Tree()
tree.insert(value: 6)
tree.insert(value: 3)
tree.insert(value: 4)
tree.insert(value: 2)
tree.insert(value: 8)
tree.insert(value: 7)
tree.insert(value: 9)
print(tree)
tree.getRandomNode()
tree.find(value: 3)
tree.delete(value: 6)
tree.root?.size // After deletion, we should have a size of 6 :)!





