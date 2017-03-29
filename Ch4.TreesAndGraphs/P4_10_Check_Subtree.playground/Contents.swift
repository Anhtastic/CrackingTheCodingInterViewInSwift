//: Playground - noun: a place where people can play

import UIKit

// Check Subtree: Tl and T2 are two very large binary trees, with Tl much bigger than T2. Create an algorithm to determine if T2 is a subtree of Tl. A tree T2 is a subtree of T1 if there exists a node n in Tl such that the subtree of n is identical to T2 . That is, if you cut off the tree at node n, the two trees would be identical.

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
    
    // Solution 1: PreOrder Traversal by building strings and compare to see if smaller string (smaller tree) is a substring of bigger string (bigger tree).
    private func convertTreeToString(root: Node?) -> String {
        var string = ""
        
        if root == nil {
            string += "X"
            return string
        }
        
        string += String(describing: root!.value)
        string += convertTreeToString(root: root?.left)
        string += convertTreeToString(root: root?.right)

        return string
    }
    
    func isSubtreePreOrderTraversal(treeOne: Node?, treeTwo: Node?) -> Bool {
        let treeOneString = convertTreeToString(root: treeOne)
        let treeTwoString = convertTreeToString(root: treeTwo)
        
        return treeOneString.range(of: treeTwoString) != nil
    }
    
    
    // Solution 2.
    private func isIdentical(treeOne: Node?, treeTwo: Node?) -> Bool {
        if treeTwo == nil && treeOne == nil {
            return true
        } else if treeTwo == nil || treeOne == nil  {
            return false
        } else if treeOne?.value != treeTwo?.value {
            return false
        } else {
            return isIdentical(treeOne: treeOne?.left, treeTwo: treeTwo?.left) && isIdentical(treeOne: treeOne?.right, treeTwo: treeTwo?.right)
        }
    }
    
    func isSubtree(treeOne: Node?, treeTwo: Node?) -> Bool {
        if treeTwo == nil {
            return true
        } else if treeOne == nil {
            return false
        } else if treeOne?.value == treeTwo?.value && isIdentical(treeOne: treeOne, treeTwo: treeTwo) {
            return true
        } else {
            return isSubtree(treeOne: treeOne?.left, treeTwo: treeTwo) || isSubtree(treeOne: treeOne?.right, treeTwo: treeTwo)
        }
    }
    
}

let treeOne = Node(value: 5)
treeOne.left = Node(value: 3)
treeOne.left?.left = Node(value: 2)
treeOne.left?.right = Node(value: 4)
print(treeOne)

let treeTwo = Node(value: 3)
treeTwo.left = Node(value: 2)
treeTwo.right = Node(value: 4)
print(treeTwo)

let result = Result()
result.isSubtree(treeOne: treeOne, treeTwo: treeTwo)
result.isSubtreePreOrderTraversal(treeOne: treeOne, treeTwo: treeTwo)

































