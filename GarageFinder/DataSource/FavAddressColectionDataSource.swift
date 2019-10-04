//
//  FavAddressColectionDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 19/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
import UIKit

class FavAddressColectionDataSource: NSObject, UICollectionViewDataSource {
    var items: [Favorite] = [Favorite(name: "Add", category: .add, latitude: -3.743993, longitude: -38.535000, type: .address),
                             Favorite(name: "Home", category: .home, latitude: -3.743993, longitude: -38.535000, type: .address),
                                    Favorite(name: "Academia do Pedro", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
                                    Favorite(name: "Academia da Maria", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
                                    Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
    Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
    Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
    Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address),
    Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address)]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavAddress", for: indexPath) as? FavAddressCollectionViewCell
        
        cell?.loadData(favoriteAddress: items[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}
