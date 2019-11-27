//
//  RatingTableViewCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 17/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    
    lazy var component: GFTableViewComponent = {
        let component = GFTableViewComponent(type: .rating)
        component.rounded(cornerRadius: 5)
        component.shadowed()
        return component
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(component)
        selectionStyle = .none
        setConstraints()
    }
    
    private func setConstraints() {
        component.anchor
            .centerY(centerYAnchor)
            .left(leftAnchor, padding: 16)
            .right(rightAnchor, padding: 16)
            .height(constant: 64)
    }
    
    func loadData(_ comment: Comment) {
        component.isCollapsed = false
        component.leftImageView.contentMode = .scaleAspectFit
        component.leftImageView.image = UIImage(named: "profile")
        component.titleLabel.text = comment.title
        component.subtitleLabel.text = comment.message
        component.ratingLabel.text = "\(comment.rating.rounded(toPlaces: 2))"
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
