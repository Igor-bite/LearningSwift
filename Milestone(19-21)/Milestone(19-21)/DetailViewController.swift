//
//  DetailViewController.swift
//  Milestone(19-21)
//
//  Created by Игорь Клюжев on 15.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var currentNote: Note!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentNote.title
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeNote))
        
        toolbarItems = [delete, spacer, compose]
        navigationController?.toolbar.isHidden = false
        
        if currentNote.title == currentNote.body.components(separatedBy: "\n")[0] {
            textView.text = """
            \(currentNote.body)
            """
        } else {
            textView.text = """
            \(currentNote.title)
            \(currentNote.body)
            """
        }
    }
    
    @objc func shareTapped() {
        if !textView.text.isEmpty {
            let vc = UIActivityViewController(activityItems: [textView.text], applicationActivities: [])
            
            present(vc, animated: true)
        } else {
            let ac = UIAlertController(title: "There is no text to share", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func deleteNote() {
        let parentVC = parent?.children[0] as? ViewController
        parentVC?.notes.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        parentVC?.tableView.deleteRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        parentVC?.save()
    }
    
    @objc func composeNote() {
        let parentVC = parent?.children[0] as? ViewController
        
        let title = textView.text.components(separatedBy: "\n")[0]

        if textView.text.isEmpty == false {
            currentNote.title = title
            currentNote.body = textView.text.components(separatedBy: "\n")[1]
            parentVC?.notes[index] = currentNote
        }
        parentVC?.tableView.reloadData()
        navigationController?.popViewController(animated: true)
        parentVC?.addNewNote()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        let parentVC = parent?.children[0] as? ViewController
        
        let title = textView.text.components(separatedBy: "\n")[0]

        if textView.text.isEmpty == false {
            currentNote.title = title
            currentNote.body = textView.text.components(separatedBy: "\n")[1]
            parentVC?.notes[index] = currentNote
        }
        parentVC?.save()
        parentVC?.tableView.reloadData()
    }
}
