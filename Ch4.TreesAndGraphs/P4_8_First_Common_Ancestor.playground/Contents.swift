//: Playground - noun: a place where people can play

import UIKit

// First Common Ancestor: Design an algorithm and write code to find the first common ancestor of two nodes in a binary tree. Avoid storing additional nodes in a data structure. NOTE: This is not necessarily a binary search tree.

class Node<T>: CustomStringConvertible {
    var left: Node?
    var right: Node?
    var parent: Node?
    var value: T
    
    init(value: T) {
        self.value = value
    }
    
    var depth: Int {
        var currentDepth = 0
        var parentNode = parent
        while parentNode != nil {
            parentNode = parentNode?.parent
            currentDepth += 1
        }
        return currentDepth
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

struct ResultAncestorChecker<T> { // Used for soln 3 to check for ancestor.
    var node: Node<T>?
    var isAncestor = false
    
    init(node: Node<T>?, isAncestor: Bool) {
        self.node = node
        self.isAncestor = isAncestor
    }
}

class Result<T> {
    
    // Solution 1: With link to parent.
    func findCommonAncestorWithParent(nodeOne: Node<T>?, nodeTwo: Node<T>?) -> Node<T>? {
        if nodeOne == nil || nodeTwo == nil { return nil }
        var depthDiff = abs(nodeOne!.depth - nodeTwo!.depth)
        var longerDepthNode = nodeOne!.depth > nodeTwo!.depth ? nodeOne : nodeTwo
        var shorterDepthNode = nodeOne!.depth > nodeTwo!.depth ? nodeTwo : nodeOne
        
        while depthDiff > 0 {
            longerDepthNode = longerDepthNode?.parent
            depthDiff -= 1
        }
        
        while shorterDepthNode !== longerDepthNode && longerDepthNode?.parent != nil && shorterDepthNode?.parent != nil {
            shorterDepthNode = shorterDepthNode?.parent
            longerDepthNode = longerDepthNode?.parent
        }
        
        return shorterDepthNode // Can return either longer or shorter node.
    }
    
    // Solution 2: With link to parent
    private func getSibling(node: Node<T>?) -> Node<T>? {
        if node == nil || node?.parent == nil { return nil }
        
        let parent = node?.parent
        return parent?.left !== node ? parent?.left : parent?.right
    }
    
    private func covers(node: Node<T>?, nodeToCover: Node<T>?) -> Bool {
        if node == nil { return false }
        if node === nodeToCover {  return true }
        
        return covers(node: node?.left, nodeToCover: nodeToCover) || covers(node: node?.right, nodeToCover: nodeToCover)
    }
    
    func findCommonAncestorWithParentTwo(node: Node<T>?, nodeTwo: Node<T>?) -> Node<T>? {
        if node == nil || nodeTwo == nil { return nil }
        
        var parent = node?.parent
        var node = node
        while parent != nil {
            let sibling = getSibling(node: node)
            if covers(node: sibling, nodeToCover: nodeTwo) {
                return parent
            }
            node = parent
            parent = parent?.parent
        }
        return parent
    }
    
    // Solution 3: Without link to parent.
    private func findCommonAncestorHelper(root: Node<T>?, nodeOne: Node<T>?, nodeTwo: Node<T>?) -> ResultAncestorChecker<T> {
        if root == nil { return ResultAncestorChecker(node: nil, isAncestor: false) }
        
        if root === nodeOne && root === nodeTwo { return ResultAncestorChecker(node: root, isAncestor: true) }
        
        let leftNode = findCommonAncestorHelper(root: root?.left, nodeOne: nodeOne, nodeTwo: nodeTwo)
        if leftNode.isAncestor { return leftNode }
        let rightNode = findCommonAncestorHelper(root: root?.right, nodeOne: nodeOne, nodeTwo: nodeTwo)
        if rightNode.isAncestor { return rightNode }
        
        if leftNode.node != nil && rightNode.node != nil {
            return ResultAncestorChecker(node: root, isAncestor: true)
        } else if root === nodeOne || root === nodeTwo {
            let isAncestor = leftNode.node != nil || rightNode.node != nil
            return ResultAncestorChecker(node: root, isAncestor: isAncestor)
        } else {
            return ResultAncestorChecker(node: leftNode.node ?? rightNode.node, isAncestor: false)
        }
    }
    
    func findCommonAncestor(root: Node<T>?, nodeOne: Node<T>?, nodeTwo: Node<T>?) -> Node<T>? {
        let result = findCommonAncestorHelper(root: root, nodeOne: nodeOne, nodeTwo: nodeTwo)
        if result.isAncestor {
            return result.node
        } else {
            return nil
        }
    }
    
    
}

let tree = Node<Int>(value: 1)
tree.left = Node(value: 2)
tree.left?.parent = tree
tree.right = Node(value: 3)
tree.right?.parent = tree
tree.left?.left = Node(value: 4)
tree.left?.left?.parent = tree.left
tree.left?.right = Node(value: 5)
tree.left?.right?.parent = tree.left
tree.right?.left = Node(value: 6)
tree.right?.left?.parent = tree.right
tree.right?.right = Node(value: 7)
tree.right?.right?.parent = tree.right
print(tree)
let result = Result<Int>()
result.findCommonAncestorWithParent(nodeOne: tree.left?.left, nodeTwo: tree.right?.right)
result.findCommonAncestorWithParent(nodeOne: tree.left?.left, nodeTwo: tree.left?.right)
result.findCommonAncestorWithParent(nodeOne: tree.left?.left, nodeTwo: tree.right?.right?.right)

result.findCommonAncestorWithParentTwo(node: tree.left?.left, nodeTwo: tree.right?.right)
result.findCommonAncestorWithParentTwo(node: tree.left?.left, nodeTwo: tree.left?.right)
result.findCommonAncestorWithParentTwo(node: tree.left?.left, nodeTwo: tree.right?.right?.right)

result.findCommonAncestor(root: tree, nodeOne: tree.left?.left, nodeTwo: tree.right?.right)
result.findCommonAncestor(root: tree, nodeOne: tree.left?.left, nodeTwo: tree.left?.right)
result.findCommonAncestor(root: tree, nodeOne: tree.left?.left, nodeTwo: tree.right?.right?.right)




