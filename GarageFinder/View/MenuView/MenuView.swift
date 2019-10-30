//
//  MenuView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class MenuView: UIView {
    typealias Action = (_ button: ButtonTap) -> Void
    
    enum ButtonTap {
        case editAccount
        case history
        case settings
        case logout
    }
        
    lazy var separatorView: UIView = {
        let sepView = UIView()
        sepView.backgroundColor = .gray
        return sepView
    }()
        
    let dataSource = MenuTableViewDataSource()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = dataSource
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView() //remove extra separators
        return tableView
    }()
    
    override func didMoveToSuperview() {
        backgroundColor = .white
        addSubviews([separatorView, tableView])
        setupConstraints()
    }
    
    func setupConstraints() {
        
        separatorView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 24)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .height(constant: 1)
        
        tableView.anchor
            .top(separatorView.bottomAnchor)
            .left(safeAreaLayoutGuide.leftAnchor)
            .right(safeAreaLayoutGuide.rightAnchor)
            .bottom(safeAreaLayoutGuide.bottomAnchor)
    }
}
