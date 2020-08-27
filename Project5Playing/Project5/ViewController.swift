//
//  ViewController.swift
//  Project5
//
//  Created by Игорь Клюжев on 19.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

struct Tuple {
    var word: String
    var score: Int
}

class TableViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    let defaults = UserDefaults.standard
    var games = 0
    
    var russian = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
        
        
        if russian {
            print("hey")
            if let startWordsURL = Bundle.main.url(forResource: "finish", withExtension: "txt") {
                print("h")
                print(startWordsURL)
                
                if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                    print("here1")
                    allWords = startWords.components(separatedBy: "\n")
                    print(allWords)
                    print("here")
                }
            }
            for item in allWords {
                if item.count > 8 {
                    print(item)
                }
            }
            if allWords.isEmpty {
                allWords = ["синхрофазатрон"]
            }
        } else {
            if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
                if let startWords = try? String(contentsOf: startWordsURL) {
                    allWords = startWords.components(separatedBy: "\n")
                }
            }
            if allWords.isEmpty {
                allWords = ["silkworm"]
            }
        }
        
        startGame()
    }

    @objc func startGame() {
        games += 1
        let word = allWords.randomElement()
        parent!.title = word
        parent!.title = parent!.title!.uppercased()
        
        let parentVC = parent as! MainViewController
        parentVC.changeScore(isStart: true)
        parentVC.findAll(for: word!) { [weak self] (array) in
            DispatchQueue.main.sync {
                let parentVC1 = self?.parent as! MainViewController
                parentVC1.infoView.updateLabels()
            }
        }
        
        let newWord = Tuple(word: word!, score: 0)
        parentVC.infoView.recent.append(newWord)
        
        print(parentVC.infoView.recent)
        
        
        parentVC.infoView.recentScore = usedWords.count
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        parentVC.infoView.updateLabels()
        parentVC.infoView.quantity += 1
        
        if games >= 2 {
            let insertionIndex = IndexPath(item: 0, section: 0)
            parentVC.infoView.collectionView?.insertItems(at: [insertionIndex])
            parentVC.infoView.collectionView?.scrollToItem(at: insertionIndex, at: .left, animated: true)
        }
        
//        parentVC.infoView.recent = word!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: parent?.title?.uppercased(), preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                           
                    if defaults.integer(forKey: "Record") < usedWords.count {
                        defaults.set(usedWords.count, forKey: "Record")
                    }
                    
                    let parentVC = parent as! MainViewController
                    parentVC.changeScore(isStart: false)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(parent!.title!.lowercased())"
        }
        
        showErrorMessage(title: errorTitle, message: errorMessage)
    }
    
    func isPossible(word: String) -> Bool {
        if word.count == 0 {
            return false
        }
        
        guard var tempWord = parent!.title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word.count < 3 || word == parent!.title!.lowercased() {
            return false
        }
        
        for usedWord in usedWords {
            if usedWord.lowercased() == word {
                return false
            }
        }
        
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if russian {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf8.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "rus")
            return misspelledRange.location == NSNotFound
        } else {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return misspelledRange.location == NSNotFound
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

