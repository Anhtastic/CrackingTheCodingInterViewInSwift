//: Playground - noun: a place where people can play

import UIKit

//  Intersection: Given two (singly) linked lists, determine if the two lists intersect. Return the intersecting node. Note that the intersection is defined based on reference, not value. That is, if the kth node of the first linked list is the exact same node (by reference) as the jth node of the second linked list, then they are intersecting.

class Node {
    
    var next: Node?
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    var description: String {
        var node = self
        var rval = "["
        while node.next != nil {
            rval += "\(node.value) -> "
            node = node.next!
        }
        return rval + "]"
    }
}

class LinkedList: CustomStringConvertible {
    
    var head: Node?
    var last: Node? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        return node
    }
    
    func insert(value: Int) {
        if let last = last {
            last.next = Node(value: value)
        } else {
            head = Node(value: value)
        }
    }
    
    func insertValues(values: [Int]) {
        for value in values {
            insert(value: value)
        }
    }
    
    var count: Int {
        var count = 0
        var node = head
        while node != nil {
            count += 1
            node = node?.next
        }
        return count
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

class Result {
    
    // Solution 1: If linked list count was already given to us.
    func findIntersectingNode(list1: LinkedList, list2: LinkedList) -> Node? {
        
        let list1Length = list1.count
        let list2Length = list2.count
        
        let longerList = list1Length > list2Length ? list1 : list2
        let shorterList = list1Length > list2Length ? list2 : list1
        var listDiff = longerList.count - shorterList.count
        var longerNode = longerList.head
        var shorterNode = shorterList.head
        
        while listDiff > 0 && longerNode != nil {
            longerNode = longerNode?.next
            listDiff -= 1
        }
        
        while longerNode != nil && shorterNode != nil {
            if longerNode === shorterNode { return longerNode }
            longerNode = longerNode?.next
            shorterNode = shorterNode?.next
        }
        
        return nil
    }
    
    // Solution 2: If we have to find the count of the lists ourselves. In this case, we can store the tail of both lists and make one check early by checking if its tails are the same. Same as above, but just one early check with the tails :)
    private func getKthNode(head: Node?, k: Int) -> Node? {
        var node = head
        var k = k
        while k > 0 && node != nil {
            node = node?.next
            k -= 1
        }
        return node
    }
    
    private func getTailAndSize(node: Node?) -> ResultWrapper {
        if node == nil { return ResultWrapper(tail: nil, size: 0) }
        
        var size = 1
        var current = node
        while current?.next != nil {
            size += 1
            current = current?.next
        }
        return ResultWrapper(tail: current, size: size)
    }
    func findIntersectingNode2(list1: LinkedList, list2: LinkedList) -> Node? {
        if list1.head == nil || list2.head == nil { return nil }
        
        let result1 = getTailAndSize(node: list1.head)
        let result2 = getTailAndSize(node: list2.head)
        
        if result1.tail !== result2.tail { return nil } // if the tail not the same, we know there's no intersection
        
        var longerNode = result1.size > result2.size ? list1.head : list2.head
        var shorterNode = result1.size > result2.size ? list2.head : list1.head
        
        longerNode = getKthNode(head: longerNode, k: abs(result1.size - result2.size))
        
        while shorterNode !== longerNode {
            shorterNode = shorterNode?.next
            longerNode = longerNode?.next
        }
        
        return shorterNode
    }
    
}

class ResultWrapper { // Wrapper for Solution 2
    var tail: Node?
    var size: Int
    init(tail: Node?, size: Int) {
        self.tail = tail
        self.size = size
    }
}

let list1 = LinkedList()
list1.insertValues(values: [1,2,3,4,5,6,7])
let list2 = LinkedList()
list2.insertValues(values: [10,11])
list2.last?.next = list1.head?.next?.next?.next?.next // Intersect at node 5
print(list1)
print(list2)
let result = Result()
result.findIntersectingNode(list1: list1, list2: list2)?.description
result.findIntersectingNode2(list1: list1, list2: list2)?.description































