//
//  ViewController.swift
//  Project1
//
//  Created by Игорь Клюжев on 13.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    @IBOutlet var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(extractPhotos), with: nil)
        print(pictures)
    }
    
    @objc fileprivate func extractPhotos() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                //this is a picture to load
                pictures.append(item)
                
            }
        }
        pictures.sort()
        
        collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? FileCell else {
            fatalError("ERROR")
        }
        cell.name.text = pictures[indexPath.item]
        cell.picture.image = UIImage(named: cell.name.text!)
        cell.picture.layer.cornerRadius = 7
        cell.picture.layer.borderWidth = 2
        cell.picture.contentMode = .scaleToFill
        cell.picture.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.index = indexPath.item
            vc.max = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

