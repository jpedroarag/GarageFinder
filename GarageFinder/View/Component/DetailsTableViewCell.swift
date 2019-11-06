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
    
    var content: UIView?

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
            .left(leftAnchor, padding: 20)
            .right(rightAnchor, padding: 20)
    }
    
    func addContentView(_ view: UIView, heightAnchor: NSLayoutDimension) {
        content = view
        addSubview(view)
        
        var anchor: NSLayoutYAxisAnchor
        if sectionHeaderLabel.text == "" || sectionHeaderLabel.text == nil {
            anchor = topAnchor
        } else {
            anchor = sectionHeaderLabel.bottomAnchor
        }
        
        var topPadding: CGFloat
        var bottomPadding: CGFloat
        if view is GarageInfoView {
            topPadding = 16
            bottomPadding = 16
        } else if view is GarageActionsView {
            topPadding = 0
            bottomPadding = 4
        } else if view is GarageGalleryView {
            topPadding = 4
            bottomPadding = 16
        } else {
            topPadding = 4
            bottomPadding = 16
        }

        view.anchor
            .top(anchor, padding: topPadding)
            .left(leftAnchor)
            .right(rightAnchor)
//            .height(heightAnchor)
            .bottom(bottomAnchor, padding: bottomPadding)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
