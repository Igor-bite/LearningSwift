//
//  DetailViewController.swift
//  Project10
//
//  Created by Игорь Клюжев on 04.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var personName: String?
    var index: Int?
    var max: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = personName
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            if let jpegData = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent(imageToLoad)) {
                imageView.image = UIImage(data: jpegData)
                imageView.contentMode = .scaleAspectFill
            } else {
                print("error")
            }
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
