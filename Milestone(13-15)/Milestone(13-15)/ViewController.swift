//
//  ViewController.swift
//  Milestone(13-15)
//
//  Created by Игорь Клюжев on 09.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UITableViewController {
    var countries: [Country]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = JSON(data)
                for country in json.array! {
                    do {
                        try parse(json: country.rawData())
                    } catch {
                        
                    }
                }
                return
            }
        }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode(Country.self, from: json) {
            
            if countries != nil {
                countries!.append(jsonCountries)
            } else {
                countries = [jsonCountries]
            }
            tableView.reloadData()
        } else {
            print("ERROR")
        }
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        vc.country = countries?[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController
//        print(countries?[indexPath.row])
        vc?.country = countries?[indexPath.row]
        present(vc!, animated: true)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let source = countries ?? [Country]()
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countries![indexPath.row].name
        
//        let urlString = countries![indexPath.row].flag
//        let url = URL(string: urlString)
//        load(url: url!)
        
        return cell
    }
}


