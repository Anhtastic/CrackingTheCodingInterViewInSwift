//: Playground - noun: a place where people can play

import UIKit

//  Animal Shelter: An animal shelter, which holds only dogs and cats, operates on a strictly "first in, first out" basis. People must adopt either the "oldest" (based on arrival time) of all animals at the shelter, or they can select whether they would prefer a dog or a cat (and will receive the oldest animal of that type). They cannot select which specific animal they would like. Create the data structures to maintain this system and implement operations such as enqueue, dequeueAny, dequeueDog, and dequeueCat. You may use the built-in LinkedList data structure.

class Node<T> {
    var next: Node<T>?
    private var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func getAnimal() -> T {
        return value
    }
}
class LinkedList<T>: CustomStringConvertible {
    
    var head: Node<T>?
    
    var last: Node<T>? {
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        return node
    }
    
    func append(value: T) {
        let newNode = Node(value: value)
        if let last = last {
            last.next = newNode
        } else {
            head = newNode
        }
    }
    
    func removeFirst() -> Node<T>? {
        if let firstElement = head {
            head = head?.next
            return firstElement
        } else {
            return nil
        }
    }
    
    
    func peek() -> Node<T>? {
        return head
    }
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    var count: Int {
        if var node = head {
            var c = 1
            while case let next? = node.next {
                node = next
                c += 1
            }
            
            return c
        } else {
            return 0
        }
    }
    
    var description: String {
        var rval = "["
        var node = head
        while node != nil {
            rval += "\(node!.getAnimal()) -> "
            node = node?.next
        }
        return rval + "]"
    }
}

class Animal {
    
    private var order: Int?
    internal var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func setOrder(order: Int) {
        self.order = order
    }
    
    func getOrder() -> Int {
        return order!
    }
    
    func isOlderThan(animal: Animal) -> Bool {
        return order! < animal.getOrder()
    }

    
}


class Cat: Animal, CustomStringConvertible {
    var description: String {
        var rval = ""
        rval += "Cat: \(name)"
        return rval
    }
}

class Dog: Animal, CustomStringConvertible {
    var description: String {
        var rval = ""
        rval += "Dog: \(name)"
        return rval
    }
}

class AnimalQueue<T>: CustomStringConvertible {
    
    let dogs = LinkedList<Dog>()
    let cats = LinkedList<Cat>()
    private var order = 0
    
    func enqueue(animal: Animal) {
        animal.setOrder(order: order)
        order += 1
        
        if animal is Dog {
            dogs.append(value: animal as! Dog)
        } else if animal is Cat {
            cats.append(value: animal as! Cat)
        }
    }
    func dequeueCats() -> Cat? {
        return cats.removeFirst()?.getAnimal()
    }
    
    func dequeueDogs() -> Dog? {
        return dogs.removeFirst()?.getAnimal()
    }
    
    func peek() -> Animal? {
        if dogs.count == 0 {
            return cats.peek()?.getAnimal()
        } else if cats.count == 0 {
            return dogs.peek()?.getAnimal()
        }
        let dog = dogs.peek()!.getAnimal()
        let cat = cats.peek()!.getAnimal()

        if dog.isOlderThan(animal: cat) {
            return dog
        } else {
            return cat
        }
    }
    
    func dequeueAny() -> Animal? {
        
        if dogs.count == 0 {
            return dequeueCats()
        } else if cats.count == 0 {
            return dequeueDogs()
        }
        
        let dog = dogs.peek()!.getAnimal()
        let cat = cats.peek()!.getAnimal()
        
        if dog.isOlderThan(animal: cat) {
            return dogs.removeFirst()?.getAnimal()
        } else {
            return cats.removeFirst()?.getAnimal()
        }
    }
    
    var description: String {
        var rval = "["
        var currentCat = cats.head
        var currentDog = dogs.head
        while currentCat != nil  || currentDog != nil {
            if currentCat == nil {
                while currentDog != nil {
                    rval += "\(currentDog!.getAnimal()) "
                    currentDog = currentDog?.next
                }
            } else if currentDog == nil {
                while currentCat != nil {
                    rval += "\(currentCat!.getAnimal()) "
                    currentCat = currentCat?.next
                }
            } else {
                let cat = currentCat!.getAnimal()
                let dog = currentDog!.getAnimal()
                if dog.isOlderThan(animal: cat) {
                    rval += "\(dog) "
                    currentDog = currentDog?.next
                } else {
                    rval += "\(cat) "
                    currentCat = currentCat?.next
                }
            }
        }
        return rval + "]"
    }
    
}

//let animals = AnimalQueue<String>()
//animals.dequeueAny()
//animals.enqueue(animal: Cat(name: "Cat1"))
//animals.enqueue(animal: Dog(name: "Dog1"))
//animals.enqueue(animal: Dog(name: "Dog2"))
//animals.enqueue(animal: Cat(name: "Cat3"))
//animals.enqueue(animal: Cat(name: "Cat4"))
//animals.enqueue(animal: Dog(name: "Dog3"))
//animals.enqueue(animal: Dog(name: "Dog4"))
//animals.enqueue(animal: Cat(name: "Cat5"))
//animals.dequeueAny()
//animals
//animals.dequeueCats()
//animals
//animals.dequeueDogs()
//animals






























