//: Playground - noun: a place where people can play

import UIKit

//  Paths with Sum: You are given a binary tree in which each node contains an integer value (which might be positive or negative). Design an algorithm to count the number of paths that sum to a given value. The path does not need to start or end at the root or a leaf, but it must go downwards (traveling only from parent nodes to child nodes).

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
            rval += "[\(left.description)] <- "
        }
        
        rval += "\(value)"
        
        if let right = right {
            rval += " -> [\(right.description)]"
        }
        
        return rval
    }
}

class Result {
    
    private func incrementMap(map: inout [Int: Int], runningSum: Int, delta: Int) {
        let value = (map[runningSum] ?? 0) + delta
        if value == 0 {
            map.removeValue(forKey: runningSum)
        } else {
            map[runningSum] = value
        }
    }
    
    private func findPathsWithSum(root: Node?, map: inout [Int: Int], runningSum: Int, targetSum: Int) -> Int {
        if root == nil { return 0 }
        
        var paths = 0
        var runningSum = runningSum
        runningSum += root!.value
        if runningSum == targetSum { paths += 1 }
        let sum = runningSum - targetSum
        if map[sum] != nil { paths += map[sum]! }
        
        incrementMap(map: &map, runningSum: runningSum, delta: 1)
        paths += findPathsWithSum(root: root?.left, map: &map, runningSum: runningSum, targetSum: targetSum)
        paths += findPathsWithSum(root: root?.right, map: &map, runningSum: runningSum, targetSum: targetSum)
        incrementMap(map: &map, runningSum: runningSum, delta: -1)
        
        return paths
    }
    
    func findPathsWithSum(root: Node?, targetSum: Int) -> Int {
        var map = [Int: Int]()
        return findPathsWithSum(root: root, map: &map, runningSum: 0, targetSum: targetSum)
    }
    
}

let tree = Node(value: 6)
tree.left = Node(value: 4)
tree.left?.left = Node(value: 3)
tree.left?.right = Node(value: -3)
tree.right = Node(value: 7)
tree.right?.right = Node(value: -6)
print(tree)

let tree2 = Node(value: 6)
tree2.left = Node(value: 1)
tree2.left?.left = Node(value: -1)
tree2.left?.left?.left = Node(value: 1)
tree2.left?.left?.left?.left = Node(value: 4)
tree2.left?.left?.left?.left?.left = Node(value: 3)
tree2.left?.left?.left?.left?.left?.left = Node(value: 4)
print(tree2)

let result = Result()
result.findPathsWithSum(root: tree, targetSum: 7)
result.findPathsWithSum(root: tree2, targetSum: 7)






































