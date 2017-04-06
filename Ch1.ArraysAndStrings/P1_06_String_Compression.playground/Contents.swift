//: Playground - noun: a place where people can play

//  String Compression: Implement a method to perform basic string compression using the counts of repeated characters. For example, the string aabcccccaaa would become a2blc5a3. If the "compressed" string would not become smaller than the original string, your method should return the original string. You can assume the string has only uppercase and lowercase letters (a - z).

func compressString(string: String) -> String {
    let chars = Array(string.characters)
    var result = ""
    var counter = 0
    for i in 0 ..< chars.count {
        counter += 1
        if (i+1) >= chars.count || chars[i] != chars[i+1] {
            result += "\(chars[i])\(counter)"
            counter = 0
        }
    }
    
    return result.characters.count < string.characters.count ? result : string
}

compressString(string: "aabcccccaaa")
compressString(string: "aabcccccaad")
compressString(string: "abcd")

















