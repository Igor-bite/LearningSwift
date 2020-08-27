//
//  ViewController.swift
//  Milestone(19-21)
//
//  Created by Игорь Клюжев on 15.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes: [Note]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = [Note]()
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.toolbar.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        title = "Notes"
        
        save()
    }
    
    @objc func addNewNote() {
        let newNote = Note()
        notes.insert(newNote, at: 0)
        let vc = (storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController)!
        vc.currentNote = newNote
        vc.index = 0
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("numberOfRowsInSection")
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = "\(notes[indexPath.row].body)"
        navigationController?.toolbar.isHidden = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
        let vc = (storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController)!
        vc.currentNote = notes[indexPath.row]
        vc.index = indexPath.row
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        save()
        tableView.reloadData()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save people.")
        }
    }
}

