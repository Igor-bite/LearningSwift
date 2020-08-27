//
//  InfoViewController.swift
//  Project5
//
//  Created by Игорь Клюжев on 21.07.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var collectionView: UICollectionView?
    let scoreLabel = UILabel()
    let recordLabel = UILabel()
    var score = 0
    var maximum: Int?
    
    var recent = [Tuple]()
    var recentScore: Int?
    var quantity = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150) // view.frame.size.height/2)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
                
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView!)
        collectionView?.backgroundColor = .white
        
        setUpLabels()
    }
    
    func updateLabels() {
        scoreLabel.text = "SCORE: \(score)/\(maximum ?? 4444)"
        let record = UserDefaults.standard.integer(forKey: "Record")
        recordLabel.text = "Record: \(record)"
    }
    
    func setUpLabels() {
        // SCORELABEL
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "SCORE: \(score)"
        scoreLabel.backgroundColor = .lightGray
        scoreLabel.alpha = 0.7
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 40)
        scoreLabel.sizeToFit()
        scoreLabel.layer.cornerRadius = 10
        scoreLabel.layer.masksToBounds = true
        
        view.addSubview(scoreLabel)
        
        scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // RECORDLABEL
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.text = "Record: \(UserDefaults.standard.integer(forKey: "Record"))"
        recordLabel.backgroundColor = .cyan
        recordLabel.alpha = 0.7
        recordLabel.font = UIFont.boldSystemFont(ofSize: 15)
        recordLabel.sizeToFit()
        recordLabel.layer.cornerRadius = 4
        recordLabel.layer.masksToBounds = true
        
        view.addSubview(recordLabel)
        
        recordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 2).isActive = true
        recordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
}

extension InfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quantity - 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView?.topAnchor.constraint(equalTo: recordLabel.bottomAnchor, constant: 20).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        print(indexPath)
        cell.textField.text = recent[recent.count - 2].word + "\n" + String(recent[recent.count-2].score)
        cell.backgroundColor = .yellow
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    
    
    fileprivate let textField: UITextView = {
        let text = UITextView()
//        let iVC = InfoViewController()
//        text.text = iVC.recent.first!.key + String(iVC.recent.first!.value)
        text.backgroundColor = .yellow
        text.font = UIFont.boldSystemFont(ofSize: 25)
        text.textColor = .red
        text.translatesAutoresizingMaskIntoConstraints = false
        text.contentMode = .scaleAspectFill
        text.clipsToBounds = true
        return text
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
         
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
