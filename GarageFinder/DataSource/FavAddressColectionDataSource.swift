//
//  FavAddressColectionDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 19/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
import UIKit

class FavAddressColectionDataSource: NSObject, UICollectionViewDataSource {
    var items: [Favorite] = []
    
    override init() {
        super.init()
        let favoriteTypeInt16 = NSNumber(value: FavoriteType.address.rawValue)
        let predicate = NSPredicate(format: "(type == %@)", favoriteTypeInt16)
        let favorites = CoreDataManager.shared.fetch(Favorite.self, predicate: predicate)
        if !favorites.isEmpty {
            items = favorites
            return
        }
        // TODO: Remove the code below later (using for testing core data)
        items = getFavorites()
        CoreDataManager.shared.saveChanges()
    }
    
    func getFavorites() -> [Favorite] {
        return [Favorite(name: "Add", category: .add, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3001),
                Favorite(name: "Home", category: .home, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3002),
                Favorite(name: "Academia do Pedro", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3003),
                Favorite(name: "Academia da Maria", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3004),
                Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3005),
                Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3006),
                Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3007),
                Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3008),
                Favorite(name: "Academia José de Alencar", category: .gym, latitude: -3.743993, longitude: -38.535000, type: .address, objectId: 3009)]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavAddress", for: indexPath) as? FavAddressCollectionViewCell
        
        cell?.loadData(favoriteAddress: items[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}
