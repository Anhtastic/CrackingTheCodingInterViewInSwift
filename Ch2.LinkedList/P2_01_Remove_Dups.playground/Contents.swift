//: Playground - noun: a place where people can play

import UIKit

// Remove Dups: Write code to remove duplicates from an unsorted linked list.
// FOLLOW UP
// How would you solve this problem if a temporary buffer is not allowed?


class Node<T> {
    var next: Node<T>?
    var value: T
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T> where T: Hashable {
    var head: Node<T>?
    var last: Node<T>? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        return node
    }
    
    func insert(value: T) {
        if let last = last {
            last.next = Node(value: value)
        } else {
            head = Node(value: value)
        }
    }
    // Solution 1
    func deleteDups() {
        var set = Set<T>()
        var node = head
        var previous: Node<T>?
        while node != nil {
            if set.contains(node!.value) {
                previous?.next = node?.next
            } else {
                set.insert(node!.value)
                previous = node
            }
            node = node?.next
        }
    }
    
    // Solution 2: What if there's no buffer? So we can't use set or dictionary huh? Well, time complexity wil be O(n²)
    func deleteDupsWithoutBuffer() {
        var current = head
        while current != nil {
            var runner = current
            while runner != nil {
                if runner?.next?.value == current?.value {
                    runner?.next = runner?.next?.next
                } else {
                    runner = runner?.next
                }
            }
            current = current?.next
        }
    }
}

extension LinkedList: CustomStringConvertible {
    internal var description: String {
        var rval = "["
        var node = head
        while node != nil {
            rval += "\(node!.value) -> "
            node = node?.next
        }
        return rval + "]"
    }
}



let list = LinkedList<String>()
list.insert(value: "A")
list.insert(value: "C")
list.insert(value: "D")
list.insert(value: "A")
list.insert(value: "A")
list.insert(value: "A")
list.insert(value: "A")
list.insert(value: "E")
list.insert(value: "C")
list.insert(value: "B")
list.deleteDups()

let list2 = LinkedList<String>()
list2.insert(value: "A")
list2.insert(value: "C")
list2.insert(value: "D")
list2.insert(value: "A")
list2.insert(value: "E")
list2.insert(value: "C")
list2.deleteDupsWithoutBuffer()






