//: Playground - noun: a place where people can play

import UIKit

//  Check Permutation: Given two strings, write a method to decide if one is a permutation of the other.

// Solution 1: Sorting
func isPermutation(string1: String, string2: String) -> Bool {
    let string1 = string1.characters.sorted()
    let string2 = string2.characters.sorted()
    
    return string1 == string2
}

isPermutation(string1: "dog", string2: "god")

// Solution 2: hash table and start counting the characters.
func isPermutationTwo(string1: String, string2: String) -> Bool {
    
    var table1 = [Character: Int]()
    var table2 = [Character: Int]()
    
    for char in string1.characters {
        if table1[char] == nil {
            table1[char] = 1
        } else {
            table1[char]! += 2
        }
    }
    
    for char in string2.characters {
        if table2[char] == nil {
            table2[char] = 1
        } else {
            table2[char]! += 2
        }
    }
    
    return table1 == table2
}

isPermutationTwo(string1: "doddg", string2: "goddd")








