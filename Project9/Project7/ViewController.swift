//
//  ViewController.swift
//  Project7
//
//  Created by Игорь Клюжев on 23.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var sortedPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(dataSourceTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
        
        performSelector(inBackground: #selector(fetchJson), with: nil)
    }
    
    @objc func fetchJson() {
        var urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"// "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            sortedPetitions = petitions
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = sortedPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = sortedPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dataSourceTapped() {
        let ac = UIAlertController(title: "The data comes from the \n\"We The People API of the Whitehouse\"", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let filter = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] (filter) in
            self?.sortedPetitions.removeAll()
            
            if ac?.textFields?[0].text == "" {
                self?.sortedPetitions = self!.petitions
            }
            
            for petition in self!.petitions {
                for word in petition.title.components(separatedBy: " ") {
                    var newWord = word.replacingOccurrences(of: ",", with: "")
                    newWord = word.replacingOccurrences(of: ".", with: "")
                    newWord = newWord.lowercased()
                    if newWord == ac?.textFields?[0].text?.lowercased() {
                        self?.sortedPetitions.append(petition)
                        break
                    }
                }
                
                for word in petition.body.components(separatedBy: " ") {
                    var newWord = word.replacingOccurrences(of: ",", with: "")
                    newWord = word.replacingOccurrences(of: ".", with: "")
                    newWord = newWord.lowercased()
                    if newWord == ac?.textFields?[0].text?.lowercased() {
                        self?.sortedPetitions.append(petition)
                        break
                    }
                }
            }
            
            if self?.sortedPetitions.isEmpty ?? true {
                self?.sortedPetitions = self!.petitions
                let ac = UIAlertController(title: "ERROR", message: "There's no titles containing this frase", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
            self?.tableView.reloadData()
        }
        
        ac.addAction(filter)
        present(ac, animated: true)
    }
}

