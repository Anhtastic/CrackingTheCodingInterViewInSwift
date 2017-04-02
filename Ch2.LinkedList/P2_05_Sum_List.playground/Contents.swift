//: Playground - noun: a place where people can play

import UIKit

//  Sum Lists: You have two numbers represented by a linked list, where each node contains a single digit. The digits are stored in reverse order, such that the 1 's digit is at the head of the list. Write a function that adds the two numbers and returns the sum as a linked list.
//  EXAMPLE
//  Input: (7-> 1 -> 6) + (5 -> 9 -> 2) .Thatis, 617 + 295.
//  Output: 2 - > 1 - > 9. That is, 912.


// FOLLOW UP
// Suppose the digits are stored in forward order. Repeat the above problem.
// Input: (6 -> 1 -> 7) + (2 -> 9 -> 5). That is, 617 + 295.
// Output: 9 - > 1 - > 2. That is, 912.

class Node {
    var next: Node?
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    
}

class LinkedList: CustomStringConvertible {
    
    var head: Node?
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
    
    internal var description: String {
        var rval = "["
        var node = head
        while node != nil {
            rval += "\(node!.value) -> "
            node = node?.next
        }
        rval += "]"
        return rval
    }
    
    var count: Int {
        var rval = 0
        var node = head
        while node != nil {
            rval += 1
            node = node?.next
        }
        return rval
    }
    
}

class Sum { // Wrapper for Forward Solution.
    var node: Node?
    var carryOver = 0
}

class Result {
    
    private func sumLists(list1: Node?, list2: Node?, carryOver: Int) -> Node? {
        if list1 == nil && list2 == nil && carryOver == 0 { return nil }
        
        let result = Node(value: 0)
        let list1Value = list1?.value ?? 0
        let list2Value = list2?.value ?? 0
        let sum = list1Value + list2Value + carryOver
        let remainder = sum % 10
        let carryOver = sum / 10
        result.value = remainder

        result.next = sumLists(list1: list1?.next, list2: list2?.next, carryOver: carryOver)
        
        return result
    }
    
    func addLists(list1: LinkedList?, list2: LinkedList?) -> LinkedList {
        let result = LinkedList()
        result.head = sumLists(list1: list1?.head, list2: list2?.head, carryOver: 0)
        return result
    }
    
    
    // FOLLOW UP
    // Suppose the digits are stored in forward order. Repeat the above problem.
    // Input: (6 -> 1 -> 7) + (2 -> 9 -> 5).That is, 617 + 295.
    // Output: 9 - > 1 - > 2. That is, 912.
    // Create a Partial Sum wrapper that keep track of the carry and result node. Get the sum result and insert a new node (with the sum) in front of the result node.
    private func insertBefore(currentNode: Node?, valueToInsert: Int) -> Node? {
        let newNode = Node(value: valueToInsert)
        newNode.next = currentNode
        return newNode
    }
    
    private func addSums(l1: Node?, l2: Node?) -> Sum {
        if l1 == nil && l2 == nil {
            return Sum()
        }
        
        let sum = addSums(l1: l1?.next, l2: l2?.next)
        
        let totalSum = (l1?.value ?? 0) + (l2?.value ?? 0) + sum.carryOver
        let remainder = totalSum % 10
        let carryOver = totalSum / 10
        
        sum.node = insertBefore(currentNode: sum.node, valueToInsert: remainder)
        sum.carryOver = carryOver
        return sum
    }
    
    private func padShorterListWithZeros(list: Node?, padding: Int) -> Node? {
        var list = list
        for _ in 1 ... padding {
            list = insertBefore(currentNode: list, valueToInsert: 0)
        }
        return list
    }
    
    func sumListsForward(list1: LinkedList, list2: LinkedList) -> LinkedList {
 
        let list1Count = list1.count
        let list2Count = list2.count
        let countDiff = abs(list1Count - list2Count)
        
        // Pad the shorter lists w/ zero's
        if countDiff > 0 {
            if list1Count > list2Count {
                list2.head = padShorterListWithZeros(list: list2.head, padding: countDiff)
            } else {
                list1.head = padShorterListWithZeros(list: list1.head, padding: countDiff)
            }
        }
        
        let sum = addSums(l1: list1.head, l2: list2.head)
        if sum.carryOver != 0 {
            sum.node = insertBefore(currentNode: sum.node, valueToInsert: sum.carryOver)
            sum.carryOver = 0
        }
        let result = LinkedList()
        result.head = sum.node
        return result
    }
    
    // Alternative Soln: Reverse all the linked lists and use our addList soln above :).
    // However, this will take a bit more time because we have to go through the lists 4x even though time complexity would still be O(n + m) where n is nodes in list1 and m is nodes in list2.
    private func reverseList(list: LinkedList) -> LinkedList {
        var current = list.head
        var prev: Node?
        while current != nil {
            let next = current?.next
            current?.next = prev
            prev = current
            current = next
        }
        
        list.head = prev
        return list
    }
    
    func sumListsForward2(list1: LinkedList, list2: LinkedList) -> LinkedList {
        let list1 = reverseList(list: list1)
        let list2 = reverseList(list: list2)
        var sumList = addLists(list1: list1, list2: list2)
        sumList = reverseList(list: sumList)
        return sumList
    }
}



let list1 = LinkedList()
list1.insertValues(values: [7,1,6])
let list2 = LinkedList()
list2.insertValues(values: [5,9,2])

let result = Result()
result.addLists(list1: list1, list2: list2)


let list3 = LinkedList()
list3.insertValues(values: [6, 9, 9, 2])
let list4 = LinkedList()
list4.insertValues(values: [6, 2, 1, 8])
result.addLists(list1: list3, list2: list4)




// Follow Up Test
let list1F = LinkedList()
list1F.insertValues(values: [6, 1, 7])
let list2F = LinkedList()
list2F.insertValues(values: [2, 9 , 5])
result.sumListsForward(list1: list1F, list2: list2F)
result.sumListsForward2(list1: list1F, list2: list2F)

let list3F = LinkedList()
list3F.insertValues(values: [2, 9, 9 , 6])
let list4F = LinkedList()
list4F.insertValues(values: [8, 1, 2, 6])
result.sumListsForward(list1: list3F, list2: list4F)
result.sumListsForward2(list1: list3F, list2: list4F)







