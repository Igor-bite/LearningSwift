//
//  ViewController.swift
//  Project2
//
//  Created by Игорь Клюжев on 13.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
        
        Button1.layer.borderWidth = 1
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        
        Button2.layer.borderWidth = 1
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        
        Button3.layer.borderWidth = 1
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        Button1.transform = .identity
        Button2.transform = .identity
        Button3.transform = .identity
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        Button1.setImage(UIImage(named: countries[0]), for: .normal)
        Button2.setImage(UIImage(named: countries[1]), for: .normal)
        Button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 7, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, correct answer is #\(correctAnswer + 1)"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
        
    }
    
    @objc func showScore() {
        let ac = UIAlertController(title: "Your score is \(score)", message: "", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: .none))
        
        present(ac, animated: true)
    }
}

