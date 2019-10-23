//
//  RentingDetailsView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class RentingDetailsViewController: UIViewController {
    
    lazy var contentView = RentingDetailsView(frame: .zero)
    
    typealias Pair = (left: String, right: String)
    private lazy var content: [Pair] = [("Valor", ""),
                                        ("Permanência", ""),
                                        ("Entrada", ""),
                                        ("Saída", "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = contentView
        contentView.tableView.dataSource = self
    }
    
    func loadData(_ renting: Parking) {
        content[0].right = renting.priceString()
        content[1].right = renting.permanenceDurationString()
        content[2].right = renting.entryDate()
        content[3].right = renting.exitDate()
        contentView.tableView.reloadData()
    }
    
}

extension RentingDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RentingDetailsCell!
        if indexPath.row < 1 {
            if let priceCell = tableView.dequeueReusableCell(withIdentifier: "rentingDetailsPriceCell", for: indexPath) as? RentingDetailsCell {
                cell = priceCell
            } else {
                return UITableViewCell()
            }
        } else {
            if let timeCell = tableView.dequeueReusableCell(withIdentifier: "rentingDetailsTimeCell", for: indexPath) as? RentingDetailsCell {
                cell = timeCell
            } else {
                return UITableViewCell()
            }
        }
        cell.leftLabel.text = content[indexPath.row].left
        cell.rightLabel.text = content[indexPath.row].right
        cell.iconImageView.image = indexPath.row > 0 ? UIImage(named: "clock") : UIImage(named: "dollarSign")
        return cell
    }
}
