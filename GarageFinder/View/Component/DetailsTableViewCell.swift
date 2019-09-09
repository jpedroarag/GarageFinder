//
//  DetailsTableViewCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 09/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    let sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    let cellContent: UIView = {
        let content = UIView()
        content.backgroundColor = .clear
        return content
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(sectionHeaderLabel)
        addSubview(cellContent)
        setConstraints()
    }
    
    private func setConstraints() {
        sectionHeaderLabel.anchor
        .top(topAnchor, padding: 16)
        .left(leftAnchor, padding: 16)
        .right(rightAnchor, padding: 16)
        cellContent.anchor
        .top(sectionHeaderLabel.bottomAnchor, padding: 8)
        .left(leftAnchor, padding: 16)
        .right(rightAnchor, padding: 16)
        .bottom(bottomAnchor, padding: 16)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
