//
//  SearchResultView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 17/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SearchResultView: UIView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        let emptyView = UIView()
        emptyView.backgroundColor = .white
        return emptyView
    }()
    
    override init(frame: CGRect) {
        let frameWithPadding = CGRect(x: 0, y: 100, width: frame.width, height: frame.height)
        super.init(frame: frameWithPadding)
        addSubview(tableView)
        //addSubview(emptyView)
        setupConstraints()
    }

    func setupConstraints() {
        tableView.anchor
            .top(topAnchor)
            .right(rightAnchor, padding: 8)
            .bottom(bottomAnchor)
            .left(leftAnchor, padding: 8)
        
//        emptyView.anchor
//            .top(topAnchor, padding: 100)
//            .right(rightAnchor, padding: 8)
//            .bottom(bottomAnchor)
//            .left(leftAnchor, padding: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
