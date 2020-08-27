//
//  DetailViewController.swift
//  Project1
//
//  Created by Игорь Клюжев on 13.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageVew: UIImageView!
    var selectedImage: String?
    var index: Int?
    var max: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectedImage != nil, "ERROR, chjsen image is not configured")
        
        title = "Picture \(index! + 1) of \(max!)"
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageVew.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
