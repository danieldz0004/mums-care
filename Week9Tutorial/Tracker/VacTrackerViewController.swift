//
//  VacTrackerViewController.swift
//  Week9Tutorial
//
//  Created by Ziyi Deng on 7/5/19.
//  Copyright © 2019 Jason Haasz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VacCell"

class VacTrackerViewController: UICollectionViewController {
    
    let imageList = [UIImage(named: "home1"),UIImage(named: "home1"),UIImage(named: "home1"),UIImage(named: "home1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VacTrackerViewCell
        
        cell.imageView.image = imageList[indexPath.row]
        cell.titleLabel.text = "\(indexPath).1"
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.center.x = cell.center.x
        
        cell.subTitleLabel.text = "\(indexPath).2"
        cell.subTitleLabel.textAlignment = .center
        cell.subTitleLabel.center.x = cell.center.x
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(jump), for: .touchUpInside)
        return cell
    }
    
    @objc func jump(sender: UIButton) {
        
    }
    
}
