//: Playground - noun: a place where people can play

import UIKit

//  Is Unique: Implement an algorithm to determine if a string has all unique characters. What if you cannot use additional data structures?

// Solution 1. Assumption: 128 characters alphabet. Either create an array of 128 Bool values or a hash table to hold on to the characters. We choose hash here.
func isUnique(string: String) -> Bool {
    
    var set = Set<Character>()
    
    if string.characters.count > 128 { return false }
    
    for char in string.characters {
        if set.contains(char) {
            return false
        } else {
            set.insert(char)
        }
    }
    
    return true
}

isUnique(string: "abcd")
isUnique(string: "abb")

// Solution 2: No additional data structures. Sort string, and compare neighboring characters - O(nlogn) because of sorting.
func isUniqueNoBuffer(string: String) -> Bool {
    let string = string.characters.sorted()
    for i in 0 ..< string.count - 1 {
        if string[i] == string[i+1] { return false }
    }
    return true
}

isUniqueNoBuffer(string: "abcd")
isUniqueNoBuffer(string: "abcdd")

































