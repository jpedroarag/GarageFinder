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
    
    // TODO: Load data from object
    func loadData() {
        
    }
    
    func loadData(title: String?, subtitle: String?, leftImage: UIImage?, rightText: String?) {
        component.titleLabel.text = title
        component.subtitleLabel.text = subtitle
        component.leftImageView.image = leftImage
        component.ratingLabel.text = rightText
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
