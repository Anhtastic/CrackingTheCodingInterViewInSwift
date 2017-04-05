//: Playground - noun: a place where people can play

import UIKit

//  URLify: Write a method to replace all spaces in a string with %20: You may assume that the string has sufficient space at the end to hold the additional characters, and that you are given the "true" length of the string. (Note: if implementing in Java, please use a character array so that you can perform this operation in place.)
//  EXAMPLE
//  Input: "Mr John Smith    ", 13
//  Output: "Mr%20John%20Smith"

func convertString(string: String, length: Int) -> String {
    
    var arrayStrings = string.characters.map { String($0) }
    for i in 0 ..< length {
        if arrayStrings[i] == " " {
            arrayStrings[i] = "%20"
        }
    }
    var result = arrayStrings.joined()
    result = result.replacingOccurrences(of: " ", with: "")
    return result
}


convertString(string: "Mr John Smith    ", length: 13)





























