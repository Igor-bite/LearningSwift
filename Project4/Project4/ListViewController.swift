//
//  ListViewController.swift
//  Project4
//
//  Created by Игорь Клюжев on 16.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var websites = ["apple.com", "yandex.ru"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Websites"
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
    
//        return 3
//    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hi")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? ViewController {
            vc.websites = websites
            vc.websiteToOpen = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
}
