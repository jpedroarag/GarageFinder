//
//  FloatingView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FloatingView: UIView {
    lazy var parentView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.rounded(cornerRadius: 5)
        return headerView
    }()
    
    lazy var pinView: CircleView = {
        let pinView = CircleView()
        pinView.backgroundColor = .customGray
        return pinView
    }()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.shadowed()
        sb.placeholder = "Onde deseja estacionar?"
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.searchBarStyle = .minimal
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.backgroundColor = .white
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.customGray.cgColor
            textfield.layer.cornerRadius = 5
            textfield.clipsToBounds = true
        }
        return sb
    }()
    
    lazy var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.rowHeight = UITableView.automaticDimension
        setupParentView()
        setupPinView()
        setupSearchBar()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupParentView() {
        addSubview(parentView)
        parentView.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .bottom(bottomAnchor)
    }
    
    func setupPinView() {
        parentView.addSubview(pinView)
        pinView.anchor
        .top(parentView.topAnchor, padding: 8)
        .centerX(parentView.centerXAnchor)
        .width(constant: 35)
        .height(constant: 5)
    }
    
    func setupSearchBar() {
        parentView.addSubview(searchBar)
        searchBar.anchor
            .top(pinView.bottomAnchor)
            .left(parentView.leftAnchor, padding: 8)
            .right(parentView.rightAnchor, padding: 8)
            .height(constant: 50)
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.bounces = false
        
        tableView.anchor
            .top(topAnchor, padding: 100)
            .bottom(bottomAnchor)
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
    }
    
}
