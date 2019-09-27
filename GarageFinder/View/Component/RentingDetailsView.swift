//
//  RentingDetailsView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 26/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class RentingDetailsView: UIView {
    let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.register(RentingDetailsCell.self, forCellReuseIdentifier: "rentingDetailsPriceCell")
        table.register(RentingDetailsCell.self, forCellReuseIdentifier: "rentingDetailsTimeCell")
        table.rounded(cornerRadius: 5)
        table.shadowed()
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .bottom(bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
