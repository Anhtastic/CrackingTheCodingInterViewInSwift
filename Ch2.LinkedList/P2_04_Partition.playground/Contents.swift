//: Playground - noun: a place where people can play

import UIKit

//  Partition: Write code to partition a linked list around a value x, such that all nodes less than x come before all nodes greater than or equal to x. If x is contained within the list, the values of x only need to be after the elements less than x (see below). The partition element x can appear anywhere in the "right partition"; it does not need to appear between the left and right partitions.
//  EXAMPLE
//  Input: 3 -> 5 -> 8 -> 5 -> 10 -> 2 -> 1 [partition = 5]
//  Output: 3 -> 1 -> 2 -> 10 -> 5 -> 5 -> 8


class Node {
    var next: Node?
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
}

class LinkedList: CustomStringConvertible {
    
    private var head: Node?
    private var last: Node? {
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
    
    // Solution 1: have a runner to run through the list and swap with current everytime the runner is less than the element to partition around. Each time we swap, we move current to next.
    func partitionList(partitionAround: Int) {
        var current = head
        if current == nil { return }
        var runner = head
        
        while runner != nil {
            if runner!.value < partitionAround {
                (current!.value, runner!.value) = (runner!.value, current!.value)
                current = current?.next
            }
            runner = runner?.next
        }
    }
    
    // Solution 2: create two pointers, and move head/tail accordingly depend on if it's less than or greater than/equal to partition element.
    func partitionList2(partitionAround: Int) {
        var headNode = head
        var tailNode = head
        var node = head
        while node != nil {
            let next = node?.next
            if node!.value < partitionAround {
                node?.next = headNode
                headNode = node
            } else {
                tailNode?.next = node
                tailNode = node
            }
            
            node = next
        }
        tailNode?.next = nil
        head = headNode
    }
    
    
    
    var description: String {
        var rval = "["
        var node = head
        while node != nil {
            rval += "\(node!.value) -> "
            node = node?.next
        }
        rval += "]"
        return rval
    }
    
}

let list = LinkedList()
list.insertValues(values: [3,5,8,5,10,2,1])
list.partitionList(partitionAround: 5)
let listSoln2 = LinkedList()
listSoln2.insertValues(values: [3,5,8,5,10,2,1])
listSoln2.partitionList2(partitionAround: 5)

// Edge test cases
let list2 = LinkedList()
list2.insertValues(values: [10, 9])
list2.partitionList(partitionAround: 5)
list2.partitionList2(partitionAround: 5)

let list3 = LinkedList()
list3.partitionList(partitionAround: 5)
list3.partitionList2(partitionAround: 5)


let list4 = LinkedList()
list4.insertValues(values: [1])
list4.partitionList(partitionAround: 5)























