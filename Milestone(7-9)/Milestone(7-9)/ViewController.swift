//
//  ViewController.swift
//  Milestone(7-9)
//
//  Created by Игорь Клюжев on 30.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var submit: UIButton!
    @IBOutlet var textField: UITextField!
    
    var score = -1 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var fails = 0
    var missedLetters = [String]()
    
    var answerArray = [String]() {
        didSet {
            answerLabel.text = answerArray.joined()
        }
    }
    var answer = "" {
        didSet {
            for letter in answer {
                answerArray.append("?")
                if !usedLetters.contains(String(letter)) {
                    usedLetters.append(String(letter).uppercased())
                }
            }
        }
    }
    
    var words: [String]!
    var usedLetters = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let wordsStr = try? String(contentsOf: url) {
                words = wordsStr.components(separatedBy: "\n")
//                print(words)
            }
        }
        textField.textAlignment = .center
        
        loadWord()
    }
    
    func loadWord() {
        fails = 0
        score += 1
        missedLetters.removeAll()
        collectionView.reloadData()
        
        usedLetters.removeAll()
        answerArray.removeAll()
        let newWord = words.randomElement()
        answer = newWord ?? "Hello"
        print(answer)
    }

    @IBAction func submitTapped(_ sender: Any) {
        if let text = textField!.text?.replacingOccurrences(of: " ", with: "") {
            if text.count == 1 {
                if usedLetters.contains(text.uppercased()) {
                    for (index, letter) in answer.enumerated() {
                        if String(letter) == text {
                            answerArray[index] = String(letter)
                        }
                    }
                } else {
                    print(fails)
                    fails += 1
                    if fails % 7 == 0 {
                        showError(title: "GAME OVER", message: nil)
                    } else {
                        showError(title: "Oops", message: "The word doesn't contain this letter")
                        missedLetters.insert(text, at: 0)
                        let insertionIndex = IndexPath(item: 0, section: 0)
                        collectionView?.insertItems(at: [insertionIndex])
                        collectionView?.scrollToItem(at: insertionIndex, at: .left, animated: true)
                    }
                }
            } else {
                showError(title: "Error", message: "You entered not a letter")
            }
        } else {
            showError(title: "Error", message: nil)
        }
        
        if !answerArray.contains("?") {
            let ac = UIAlertController(title: "You made it!", message: "You guessed word \(answer.uppercased())", preferredStyle: .alert)
            let action = UIAlertAction(title: "NEXT", style: .default) { [weak self] (action) in
                self?.loadWord()
            }
            
            ac.addAction(action)
            present(ac, animated: true)
        }
        
        textField.text = ""
        
        
    }
    
    func showError(title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missedLetters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? LetterCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        cell.letter.text = missedLetters[indexPath.item]
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor 
        return cell
    }
}

