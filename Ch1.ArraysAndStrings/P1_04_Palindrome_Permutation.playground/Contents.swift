//: Playground - noun: a place where people can play

import UIKit

//  Palindrome Permutation: Given a string, write a function to check if it is a permutation of a palindrome. A palindrome is a word or phrase that is the same forwards and backwards. A permutation is a rearrangement of letters. The palindrome does not need to be limited to just dictionary words.
//  EXAMPLE
//  Input: Tact Coa
//  Output: True (permutations:"taco cat'; "atco cta'; etc.)

func isPalindromePermutation(string: String) -> Bool {
    let string = string.replacingOccurrences(of: " ", with: "").lowercased()
    let chars = Array(string.characters)
    var table = [Character: Int]()
    
    for char in chars {
        if table[char] == nil {
            table[char] = 1
        } else {
            table[char]! += 1
        }
    }
    
    var oddCount = 0
    for value in table.values {
        if value % 2 != 0 {
            oddCount += 1
        }
    }
    
    return oddCount > 1 ? false : true

}

isPalindromePermutation(string: "Tact Coa")



























