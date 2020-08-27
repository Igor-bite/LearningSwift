import UIKit

var str = "Hello, playground"

var age = 38
var population = 8_000_000

var str1 = """
This goes
over multiple
lines
"""

var str2 = """
This goes \
over multiple \
line
"""

var pi = 3.141
var awesome = true

var score = 85
var str3 = "Your score was \(score)"
var str4 = "The test results are here:  \(str3)"

let taylor = "swift"

let str5 = "Hello"
let album: String = "Reputation"
let year: Int = 1989
let height: Double = 1.78
let taylorRocks: Bool = true

class Animal {
    static var count: Int = 0
    let name: String
    var breed: String
    var sound = {() -> String in
        return "Woof"
    }
    var amount: Int
    
    func playSound(){
        let mes = sound()
        print("\(name) says \(mes)")
    }
    
    init(name: String, breed: String, amount: Int) {
        print("\(name) was born")
        self.name = name
        self.breed = breed
//        self.sound = sound
        self.amount = amount
//        count += 1
    }
}

class Dog: Animal {
    override func playSound() {
        print("\(name) says like a dog")
    }
}

var pudel = Dog(name: "Pusha", breed: "Pudel", amount: 2)

pudel.playSound()

let quantity = { (obj: Dog) -> Int in
    print("there are \(obj.amount) dogs")
    return obj.amount
}

var temp = quantity(pudel)

if temp == 1 {
    print("here 1")
} else if temp == 2 {
    print("here 2")
}

// MARK: Functions

func favoriteAlbum(is name: String) {
    print("My favorite is \(name)")
}

favoriteAlbum(is: "Fearless")

func printAlbumRelease(name: String, year: Int) {
    print("\(name) was released in \(year)")
}

printAlbumRelease(name: "Fearless", year: 2000)

func countLetters(_ str: String) {
    print("The string \(str) has \(str.count) letters")
}

countLetters("Hello")

func albumIsTaylors(name: String) -> Bool {
    if name == "Taylor Swift" { return true }
    if name == "Fearless" { return true }
    return false
}

// MARK: Optionals

func getHaterStatus(_ weather: String) -> String? {
    if weather == "sunny" {
        return nil
    } else {
        return "Hate"
    }
}

var status: String?
status = getHaterStatus("rainy")

func takeHaterAction(status: String) {
    if status == "Hate" {
        print("Hating")
    }
}

if let haterStatus = getHaterStatus("rainy") {
    takeHaterAction(status: haterStatus)
}

func yearAlbumReleased(name: String) -> Int? {
    if name == "Taylor Swift" { return 2006 }
    if name == "Fearless" { return 2008 }
    return nil
}

var items = ["James", "John", "Sally"]

func position(of string: String, in array: [String]) -> Int? {
    for i in 0..<array.count {
        if array[i] == string {
            return i
        }
    }
    
    return nil
}

let JamesPosition = position(of: "James", in: items)
let JohnPosition = position(of: "John", in: items)
let SallyPosition = position(of: "Sally", in: items)
let BobPosition = position(of: "Bob", in: items)
