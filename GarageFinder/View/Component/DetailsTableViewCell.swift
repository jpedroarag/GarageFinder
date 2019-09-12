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
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(rgb: 0x000000, alpha: 60)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(sectionHeaderLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        sectionHeaderLabel.anchor
            .top(topAnchor, padding: 16)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
    }
    
    func addContentView(_ view: UIView) {
        addSubview(view)
        
        var anchor: NSLayoutYAxisAnchor
        if sectionHeaderLabel.text == "" || sectionHeaderLabel.text == nil {
            anchor = topAnchor
        } else {
            anchor = sectionHeaderLabel.bottomAnchor
        }

        view.anchor
            .top(anchor, padding: 16)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .bottom(bottomAnchor, padding: 16)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
