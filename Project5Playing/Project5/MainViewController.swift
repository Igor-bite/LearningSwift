//
//  MainViewController.swift
//  Project5
//
//  Created by Игорь Клюжев on 21.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let tableView = TableViewController()
    let infoView = InfoViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        addChildVCs()
//        tableView.startGame()
    }
    
    private func addChildVCs() {
        addChild(tableView)
        addChild(infoView)
        
        view.addSubview(tableView.view)
        view.addSubview(infoView.view)
        
        tableView.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height*3/5)
        infoView.view.frame = CGRect(x: 0, y: view.frame.size.height*3/5, width: view.frame.size.width, height: view.frame.size.height*2/5)
        
        tableView.didMove(toParent: self)
        infoView.didMove(toParent: self)
        infoView.view.backgroundColor = .white
    }
    
    func changeScore(isStart: Bool) {
        if !isStart {
            self.infoView.score += 1
            self.infoView.recent[self.infoView.recent.count - 1].score += 1
            self.infoView.updateLabels()
            
        } else {
            self.infoView.score = 0
            self.infoView.updateLabels()
        }
        
    }
    
    func findAll(for word: String, _ completion: @escaping (NSArray) -> ()) {
        let urlString: String
        //FIX
        if tableView.russian {
            urlString = "http://www.anagramica.com/all/:silkworm"
        } else {
            urlString = "http://www.anagramica.com/all/:\(word)"
        }
        
        let url = URL(string: urlString)
                
        let task = URLSession.shared.dataTask(with: url!) { [weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : [String]]
                
                var words = json["all"] ?? [String]()
                while words.last?.count ?? 1000 < 3 {
                    _ = words.popLast()
                }
                
                self!.infoView.maximum = words.count
                completion(words as NSArray)
            }
            catch let error {
                print(error)
            }
        }
        
        task.resume()
    }
    
    @objc func promptForAnswer() {
        tableView.promptForAnswer()
    }
    
    @objc func startGame() {
        tableView.startGame()
    }
}
