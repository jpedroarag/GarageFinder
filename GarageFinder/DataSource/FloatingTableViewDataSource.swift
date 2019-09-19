//
//  FloatingTableViewDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 19/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingTableViewDataSource: NSObject, UITableViewDataSource {
    
    var favoriteGarages: [String] = ["Garagem de Marcus", "Garagem de Pedro", "Garagem de Joaquim",
                                     "Garagem de Marcus", "Garagem de Pedro", "Garagem de Joaquim"]
    
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
                favGaragesCell.loadData(titleLabel: favoriteGarages[indexPath.row], address: "Av 13 de Maio, 152", ownerImage: UIImage(named: "mockPerson"))
                cell = favGaragesCell
            }
        }
        
        return cell ?? UITableViewCell()
    }
}
