//
//  GarageRatingListViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class GarageRatingListViewController: UIViewController {
    
    lazy var ratings: [Comment] = []
    
    lazy var ratingsTable: UITableView = {
        let ratingsTable = UITableView()
        ratingsTable.backgroundColor = .clear
        ratingsTable.separatorStyle = .none
        ratingsTable.isScrollEnabled = false
        ratingsTable.register(RatingTableViewCell.self, forCellReuseIdentifier: "ratingCell")
        ratingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "noRatings")
        return ratingsTable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = ratingsTable
        ratingsTable.delegate = self
        ratingsTable.dataSource = self
    }
    
    func loadRatings(_ ratings: [Comment]) {
        self.ratings = ratings
        ratingsTable.reloadData()
    }

}

extension GarageRatingListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.isEmpty ? 1 : ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ratings.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noRatings", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "Não há avaliações disponíveis para esta garagem ainda"
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingTableViewCell else {
                return UITableViewCell()
            }
            cell.loadData(ratings[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ratings.isEmpty ? UITableView.automaticDimension : 64 + 8
    }
    
}
