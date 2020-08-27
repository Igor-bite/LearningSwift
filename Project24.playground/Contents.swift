import UIKit

// MARK: - PART 1
let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

// MARK: - PART 2

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

// MARK: - PART 3

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

// MARK: - PART 4

let input = "Swift is like Pbjective-C withput C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)

// MARK: - PART 5.1

let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

// MARK: - PART 5.2

let myString = "This is a test string"
let attributedMutableString = NSMutableAttributedString(string: myString)

attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedMutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

// MARK: - FOR CHALLENGE

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return prefix + self
    }
    
    func isNumeric() -> Bool {
        if Double(self) != nil {
            return true
        } else {
            return false
        }
    }
    
    func makeArray() -> [String] {
        var str = ""
        var result = [String]()
        for (index, letter) in self.enumerated() {
            if letter != "\n" && index != (self.count - 1) {
                str.append(letter)
            } else if letter == "\n" {
                result.append(str)
                str = ""
            } else if index == self.count - 1 {
                str.append(letter)
                result.append(str)
            }
        }
        return result
    }
}

let MyString = """
This
is
a
test
"""
print(MyString.makeArray())

let numeric = "1232"
let notNumeric = "2jf3"
numeric.isNumeric()
notNumeric.isNumeric()

let car = "car"
let pet = "pet"

pet.withPrefix(car)

// MARK: - FOR MILESTONE

// - Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 3)

// - Extend Int with a times() method that runs a closure as many times as the number is high. For example, 5.times { print("Hello!") } will print “Hello” five times.

extension Int { 
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

5.times {
    print("Hello world!")
}


// - Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it finds. Tip: you will need to add the Comparable constraint to make this work!

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        for (index, element) in self.enumerated() {
            if element == item {
                self.remove(at: index)
                return
            }
        }
    }
}

var array = ["hello", "world", "nkjbfjh", "hello", "bhwed", "world", "lnghj", "kjrjfkj"]

array.remove(item: "hello")

var newArray = ["hello", "world", "nkjbfjh", "hello", "bhwed", "world", "lnghj", "kjrjfkj"]
newArray.remove(item: "world")
