//
//  FavAddressColectionDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 19/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
import UIKit

class FavAddressColectionDataSource: NSObject, UICollectionViewDataSource {
    var items: [String] = ["Home", "Gym", "Market", "Home", "Gym", "Market"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavAddress", for: indexPath) as? FavAddressCollectionViewCell
        
        var imageName = "home"
        
        if indexPath.row == 0 {
            imageName = "plus"
        }
        cell?.loadData(icon: UIImage(named: imageName))
        return cell ?? UICollectionViewCell()
    }
}
