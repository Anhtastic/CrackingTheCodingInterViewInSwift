//: Playground - noun: a place where people can play

import UIKit
// Minimal Tree: Given a sorted (increasing order) array with unique integer elements, write an algorithm to create a binary search tree with minimal height.

class Node: CustomStringConvertible {
    var left: Node?
    var right: Node?
    private var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    internal var description: String {
        var rval = ""
        if let left = left {
            rval += "(\(left.description)) <- "
        }
        rval += String(value)
        if let right = right {
            rval += " -> (\(right.description))"
        }
        return rval
    }
}

func createBinaryTreeHelper(array: [Int], startingIndex: Int, endingIndex: Int) -> Node? {
    if array.isEmpty { return nil }
    if startingIndex > endingIndex { return nil }
    let middleIndex = (startingIndex + endingIndex)/2
    let middleElement = array[middleIndex]
    let root = Node(value: middleElement)
    root.left = createBinaryTreeHelper(array: array, startingIndex: startingIndex, endingIndex: middleIndex - 1)
    root.right = createBinaryTreeHelper(array: array, startingIndex: middleIndex + 1, endingIndex: endingIndex)
    return root
}

func createBinaryTree(array: [Int]) -> Node? {
    return createBinaryTreeHelper(array: array, startingIndex: 0, endingIndex: array.count - 1)
}

let emptyArray = [Int]()
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let emptyTree = createBinaryTree(array: emptyArray)
let binarySearchTree = createBinaryTree(array: array)
if binarySearchTree != nil {
    print(binarySearchTree!)
}



