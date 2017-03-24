//: Playground - noun: a place where people can play

import UIKit

// Route Between Nodes: Given a directed graph, design an algorithm to find out whether there is a route between two nodes.

class Node<T> {
    private var neighbors = [Node]()
    private var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func createEdge(node: Node?) {
        if node == nil { return }
        neighbors.append(node!)
    }
    
    var isEmpty: Bool {
        return neighbors.isEmpty
    }
    
    func getChildren() -> [Node] {
        return neighbors
    }
    
    func getValue() -> T {
        return value
    }
}

class Search<T> {
    // Assumption: Graph cannot be circular. (e.g. A -> B -> C -> A)
    // Solution 1: Depth First Search
    func dFSBetweenNodes(node1: Node<T>?, node2: Node<T>?) -> Bool {
        if node1 == nil || node2 == nil { return false }
        if node1 === node2 { return true }

        if let children = node1?.getChildren() {
            for child in children {
                if dFSBetweenNodes(node1: child, node2: node2) {
                    return true
                }
            }
        }
        return false
    }
    
    // Solution 2: Breadth First Search
    func bFSBetweenNodes(node1: Node<T>?, node2: Node<T>?) -> Bool {
        if node1 == nil || node2 == nil { return false }
        if node1 === node2 { return true }
        
        // There's a few alternatives to doing this.
        // 1. Create a queue but removing first element from an array is costly.
        // 2. Create a linked list and thus resolve the issue from alternative 1.
        // 3. Create a stack but need to create a tempStack array to hold on to the removed elements and replace it as the new stack.
        guard var stack = node1?.getChildren() else { return false }
        while !stack.isEmpty {
            var tempStack = [Node<T>]()
            for index in stride(from: stack.count - 1, through: 0, by: -1) {
                if stack[index] === node2 { return true }
                let removeNode = stack.removeLast()
                let children = removeNode.getChildren()
                tempStack.append(contentsOf: children)
            }
            stack = tempStack
        }
        return false
    }
}


let nodeA = Node(value: "A")
let nodeB = Node(value: "B")
let nodeC = Node(value: "C")
let nodeD = Node(value: "D")
let nodeE = Node(value: "E")
let nodeF = Node(value: "F")
let nodeG = Node(value: "G")
let nodeH = Node(value: "H")
nodeA.createEdge(node: nodeB)
nodeA.createEdge(node: nodeC)
nodeB.createEdge(node: nodeD)
nodeB.createEdge(node: nodeE)
nodeC.createEdge(node: nodeF)
nodeC.createEdge(node: nodeG)
nodeE.createEdge(node: nodeF)
nodeE.createEdge(node: nodeH)
nodeF.createEdge(node: nodeG)

let search = Search<String>()

search.dFSBetweenNodes(node1: nodeA, node2: nodeH)
search.dFSBetweenNodes(node1: nodeC, node2: nodeH)

search.bFSBetweenNodes(node1: nodeA, node2: nodeH)
search.bFSBetweenNodes(node1: nodeC, node2: nodeH)