//: Playground - noun: a place where people can play

import UIKit

//  String Rotation: Assume you have a method isSubstring which checks if one word is a substring of another. Given two strings, s1 and s2, write code to check if s2 is a rotation of s1 using only one call to isSubstring 

//  Example: s1: "erbottlewat" , s2: "waterbottle"
//               "waterbottle" is a rotation of "erbottlewat" -> true


func isRotation(s1: String, s2: String) -> Bool {
    let s2s2 = s2 + s2
    if s1.characters.count == s2.characters.count {
        return s2s2.contains(s1)
    } else {
        return false
    }
}
let s1 = "erbottlewat"
let s2 = "waterbottle"
isRotation(s1: s1, s2: s2)
isRotation(s1: "o", s2: "yo")