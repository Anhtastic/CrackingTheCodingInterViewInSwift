//: Playground - noun: a place where people can play

import UIKit

//  One Away: There are three types of edits that can be performed on strings: insert a character, remove a character, or replace a character. Given two strings, write a function to check if they are one edit (or zero edits) away.
//  EXAMPLE
//  pale, ple -> true
//  pales, pale -> true
//  pale, bale -> true
//  pale, bae -> false

class Result {
    
    private func oneEditReplacement(s1: String, s2: String) -> Bool {
        var index1 = 0
        var index2 = 0
        let s1Chars = Array(s1.characters)
        let s2Chars = Array(s2.characters)
        var replacementFound = false
        
        while index1 < s1Chars.count && index2 < s2Chars.count {
            if s1Chars[index1] != s2Chars[index2] {
                if replacementFound {
                    return false
                }
                replacementFound = true
            }
            index1 += 1
            index2 += 1
        }
        return true
    }
    
    private func oneEditInsert(s1: String, s2: String) -> Bool {
        var index1 = 0
        var index2 = 0
        let s1Chars = Array(s1.characters)
        let s2Chars = Array(s2.characters)
        
        while index1 < s1Chars.count && index2 < s2Chars.count {
            if s1Chars[index1] != s2Chars[index2] {
                if index1 != index2 {
                    return false
                }
                index2 += 1
            }
            index1 += 1
            index2 += 1
        }
        return true
    }
    
    // Solution 1: More readable code
    func oneEditAway(s1: String, s2: String) -> Bool {
        let s1Count = s1.characters.count
        let s2Count = s2.characters.count
        
        if abs(s1Count - s2Count) > 1 {
            return false
        } else if s1Count == s2Count {
            return oneEditReplacement(s1: s1, s2: s2)
        } else if s1Count > s2Count {
            return oneEditInsert(s1: s2, s2: s1)
        } else {
            return oneEditInsert(s1: s1, s2: s2)
        }
    }

    // Solution 2: A bit less readable but less duplicate code.
    func oneEditAwayLessDupCode(s1: String, s2: String) -> Bool {
        if abs(s1.characters.count - s2.characters.count) > 1 { return false }
        var index1 = 0
        var index2 = 0
        let s1Chars = Array(s1.characters)
        let s2Chars = Array(s2.characters)
        var replacementFound = false
        
        let longerString = s1Chars.count > s2Chars.count ? s1Chars : s2Chars
        let shorterString = s1Chars.count > s2Chars.count ? s2Chars : s1Chars

        while index1 < shorterString.count && index2 < longerString.count {
            if shorterString[index1] != longerString[index2] {
                if index1 != index2 || replacementFound {
                    return false
                }
                if shorterString.count == longerString.count {
                    index1 += 1
                    index2 += 1
                } else {
                    index2 += 1
                }
                replacementFound = true
            } else {
                index1 += 1
                index2 += 1
            }
        }
        return true
    }
    
    
}
let result = Result()
result.oneEditAway(s1: "pale", s2: "ple")
result.oneEditAway(s1: "pales", s2: "pale")
result.oneEditAway(s1: "pale", s2: "bale")
result.oneEditAway(s1: "ale", s2: "pale")
result.oneEditAway(s1: "pale", s2: "bae")
result.oneEditAway(s1: "pale", s2: "paleee")

result.oneEditAwayLessDupCode(s1: "pale", s2: "ple")
result.oneEditAwayLessDupCode(s1: "pales", s2: "pale")
result.oneEditAwayLessDupCode(s1: "pale", s2: "bale")
result.oneEditAwayLessDupCode(s1: "ale", s2: "pale")
result.oneEditAwayLessDupCode(s1: "pale", s2: "bae")
result.oneEditAwayLessDupCode(s1: "pale", s2: "paleee")









