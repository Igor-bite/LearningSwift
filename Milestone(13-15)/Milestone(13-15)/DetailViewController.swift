//
//  DetailViewController.swift
//  Milestone(13-15)
//
//  Created by Игорь Клюжев on 09.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var country: Country?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var capitalLabel: UILabel!
    @IBOutlet var regionLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = country?.name
        capitalLabel.text = country?.capital
        regionLabel.text = country?.region
        populationLabel.text = "\(country?.population ?? 0)"
        if let url = URL(string: country!.flag) {
            load(url: url)
        }
    }
    
    func load(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
