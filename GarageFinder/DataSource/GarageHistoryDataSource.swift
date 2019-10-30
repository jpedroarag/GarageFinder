//
//  GarageHistoryDataSource.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageHistoryDataSource: NSObject, UITableViewDataSource {
    var garages: [Favorite] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return garages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let garageCell = tableView.dequeueReusableCell(withIdentifier: "FavGarages", for: indexPath) as? FavGaragesTableViewCell
            garageCell?.loadData(garages[indexPath.row])
        
        return garageCell ?? UITableViewCell()
    }
}
