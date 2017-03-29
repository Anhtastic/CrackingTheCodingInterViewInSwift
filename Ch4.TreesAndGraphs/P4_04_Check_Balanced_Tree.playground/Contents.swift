//: Playground - noun: a place where people can play

import UIKit


// Check Balanced: Implement a function to check if a binary tree is balanced. For the purposes of this question, a balanced tree is defined to be a tree such that the heights of the two subtrees of any node never differ by more than one.

class Node<T>: CustomStringConvertible {
    var left: Node?
    var right: Node?
    
    var value: T
    init(value: T) {
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

class Result<T> {
    
    private func heightChecker(root: Node<T>?) -> Int {
        if root == nil { return -1 }
        
        let leftHeight = heightChecker(root: root?.left)
        if leftHeight == Int.min { return Int.min }
        let rightHeight = heightChecker(root: root?.right)
        if rightHeight == Int.min { return Int.min }
        
        if abs(leftHeight - rightHeight) >  1 {
            return Int.min
        } else {
            return max(leftHeight, rightHeight) + 1
        }
    }
    
    func isTreeBalanced(root: Node<T>?) -> Bool {
        return heightChecker(root: root) != Int.min
    }
    
}

let treeOne = Node<Int>(value: 1)
treeOne.left = Node(value: 2)
treeOne.left?.left = Node(value: 3)
treeOne.left?.left?.left = Node(value: 4)
treeOne.right = Node(value: 5)
print(treeOne)
let result = Result<Int>()
result.isTreeBalanced(root: treeOne)


let treeTwo = Node<Int>(value: 1)
treeTwo.left = Node(value: 2)
treeTwo.left?.left = Node(value: 3)
treeTwo.right = Node(value: 5)
treeTwo.right?.right = Node(value: 6)
print(treeTwo)
let resultTwo = Result<Int>()
resultTwo.isTreeBalanced(root: treeTwo)

result.isTreeBalanced(root: nil) // if no node, we return -1, which is not Int.min, thus true!



