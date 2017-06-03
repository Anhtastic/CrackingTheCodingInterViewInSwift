//: Playground - noun: a place where people can play

import UIKit

//  File System: Explain the data structures and algorithms that you would use to design an in-memory file system. Illustrate with an example in code where possible.

class Entry {
    
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.name == rhs.name
    }
    
    fileprivate var parent: Directory?
    fileprivate var created: Date
    fileprivate var lastUpdated: Date?
    fileprivate var lastAccessed: Date?
    fileprivate var name: String
    
    init(name: String, parent: Directory?) {
        self.name = name
        self.parent = parent
        created = Date()
    }
    
    func delete() -> Bool {
        if parent == nil { return false }
        return parent!.deleteEntry(entry: self)
    }
    
    func size() -> Int { return 1 }
    
    func getFullPath() -> String {
        if parent == nil {
            return name
        } else {
            return (parent?.getFullPath())! + "/" + name
        }
        
    }
    
    func getCreationTime() -> Date {
        return created
    }
    
    func getLastUpdatedTime() -> Date? {
        return lastUpdated
    }
    
    func getLastAccessedTime() -> Date? {
        return lastAccessed
    }
    
    func changeName(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
}


class File: Entry {
    fileprivate var content: String?
    fileprivate var size: Int
    
    init(name: String, parent: Directory?, size: Int) {
        self.size = size
        super.init(name: name, parent: parent)
    }
    
    func getSize() -> Int  {
        return size
    }
    
    func getContents() -> String? {
        return content
    }
    
    func setContents(content: String) {
        self.content = content
    }
    
}


class Directory: Entry {
    fileprivate var contents = [Entry]()
    
    func getContents() -> [Entry] {
        return contents
    }
    
    func getContentsNames() ->[String] {
        var res = [String]()
        for content in contents {
            res.append(content.getName())
        }
        return res
    }
    
    override func size() -> Int {
        var size = 0
        for entry in contents {
            size += entry.size()
        }
        return size
    }
    
    func numberOfFiles() -> Int {
        var count = 0
        for entry in contents {
            if entry is Directory {
                count += 1
                let d = entry as! Directory
                count += d.numberOfFiles()
            } else if entry is File {
                count += 1
            }
        }
        return count
    }
    
    
    func deleteEntry(entry: Entry) -> Bool {
        for (index, content) in contents.enumerated() {
            if content == entry {
                contents.remove(at: index)
                return true
            }
        }
        return false
    }
    
    func addEntry(entry: Entry) {
        contents.append(entry)
    }
    
    
}

class Test {
    func beginTest() {
        let root = Directory(name: "Food", parent: nil)
        let taco = File(name: "Taco", parent: root, size: 4)
        let hamburger = File(name: "Hamburger", parent: root, size: 9)
        root.addEntry(entry: taco)
        root.addEntry(entry: hamburger)
        
            let healthy = Directory(name: "Healthy", parent: root)
        
                let fruits = Directory(name: "Fruits", parent: healthy)
                    let apple = File(name: "Apple", parent: fruits, size: 5)
                    let banana = File(name: "Banana", parent: fruits, size: 6)
                fruits.addEntry(entry: apple)
                fruits.addEntry(entry: banana)
        
            healthy.addEntry(entry: fruits)
        
                let veggies = Directory(name: "Veggies", parent: healthy)
                    let carrot = File(name: "Carrot", parent: veggies, size: 6)
                    let lettuce = File(name: "Lettuce", parent: veggies, size: 7)
                    let peas = File(name: "Peas", parent: veggies, size: 4)
                veggies.addEntry(entry: carrot)
                veggies.addEntry(entry: lettuce)
                veggies.addEntry(entry: peas)
        
            healthy.addEntry(entry: veggies)
        
        root.addEntry(entry: healthy)
        print(root.getContentsNames())
        print(healthy.getContentsNames())
        print(fruits.getContentsNames())
        print(veggies.getContentsNames())
        print(fruits.getFullPath())
        print(veggies.getFullPath())
        print(root.numberOfFiles())
        print(root.getCreationTime())
    }
}

let test = Test()
test.beginTest()


























