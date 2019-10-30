//
//  GarageHistoryView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageHistoryView: UIView {
    
    lazy var separatorView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = .gray
        return sepView
    }()
    
    let dataSource = GarageHistoryDataSource()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavGaragesTableViewCell.self, forCellReuseIdentifier: "FavGarages")
        tableView.bounces = false
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        return tableView
    }()

    func setData(garages: [Favorite]) {
        dataSource.garages = garages
        tableView.reloadData()
    }
    
    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([separatorView, tableView])
        setupConstraints()
    }
    func setupConstraints() {
        separatorView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 2)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .height(constant: 1)
        tableView.anchor
            .attatch(to: self.safeAreaLayoutGuide, paddings: [.top(16),
                                                              .left(8),
                                                              .right(8)])
    }
}
