//
//  FloatingTableViewDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 19/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingTableViewDataSource: NSObject, UITableViewDataSource {
    
    var favoriteGarages: [Favorite] = []
    
    override init() {
        super.init()
        let favorites = loadFavorites()
        if !favorites.isEmpty {
            favoriteGarages = favorites
            return
        }
        // TODO: Remove the code below later (using for testing core data)
        favoriteGarages = getFavorites()
        CoreDataManager.shared.saveChanges()
    }
    
    func getFavorites() -> [Favorite] {
        return [Favorite(name: "Garagem de Marcus", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1001),
                Favorite(name: "Garagem de Vitor", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1002),
                Favorite(name: "Garagem de Pedro", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1003),
                Favorite(name: "Garagem de Joaquim", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1004),
                Favorite(name: "Garagem de Dano;p", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1005)]
    }
    
    func loadFavorites() -> [Favorite] {
        let favoriteTypeInt16 = NSNumber(value: FavoriteType.garage.rawValue)
        let predicate = NSPredicate(format: "(type == %@)", favoriteTypeInt16)
        return CoreDataManager.shared.fetch(Favorite.self, predicate: predicate)
    }
    
    func reloadFavorites() {
        favoriteGarages = loadFavorites()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return favoriteGarages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            if let favAddressCell = tableView.dequeueReusableCell(withIdentifier: "FavAddress", for: indexPath) as? FavAddressTableViewCell {
                cell = favAddressCell
            }
        } else {
            if let favGaragesCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell {
                favGaragesCell.loadData(favoriteGarages[indexPath.row])
                cell = favGaragesCell
            }
        }
        
        return cell ?? UITableViewCell()
    }
}
