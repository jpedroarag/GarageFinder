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
    }
    
    func getFavorites() -> [Favorite] { // Data for testing
        return [Favorite(name: "Garagem de Marcus", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1001, average: 4.3),
                Favorite(name: "Garagem de Vitor", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1002, average: 4.6),
                Favorite(name: "Garagem de Pedro", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1003, average: 4),
                Favorite(name: "Garagem de Joaquim", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1004, average: 4.3),
                Favorite(name: "Garagem de Dano;p", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage, objectId: 1005, average: 4.7)]
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
//        return 2
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        default:
//            return favoriteGarages.count
//        }
        if favoriteGarages.count == 0 {
            return 1
        } else {
            return favoriteGarages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
//        if indexPath.section == 0 {
//            if let favAddressCell = tableView.dequeueReusableCell(withIdentifier: "FavAddress", for: indexPath) as? FavAddressTableViewCell {
//                cell = favAddressCell
//            }
//        } else {
//            if let favGaragesCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell {
//                favGaragesCell.loadData(favoriteGarages[indexPath.row])
//                cell = favGaragesCell
//            }
//        }
        if favoriteGarages.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell?.textLabel?.text = "Você ainda não possui garagens favoritas"
        } else if let favGaragesCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell {
            favGaragesCell.loadData(favoriteGarages[indexPath.row])
            cell = favGaragesCell
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorite = favoriteGarages.remove(at: indexPath.row)
            CoreDataManager.shared.delete(object: favorite)
            tableView.reloadData()
        }
    }
    
}
