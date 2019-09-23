//
//  GarageRatingsDataSourceDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 17/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

struct Rating {
    var title: String
    var subtitle: String
    var rating: String
}

class GarageRatingsDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var ratings: [Rating] = []
    
    init(ratings: [Rating]) {
        self.ratings = ratings
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingTableViewCell else { return UITableViewCell() }
        let rating = ratings[indexPath.row]
        cell.loadData(title: rating.title, subtitle: rating.subtitle, leftImage: UIImage(named: "mock"), rightText: rating.rating)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 + 4
    }
    
}
