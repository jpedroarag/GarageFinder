//
//  GarageInfoView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageInfoView: UIView {
    
    lazy var parkButton: GFButton = {
        let button = GFButton(frame: .zero)
        button.setTitle("Estacionar", for: .normal)
        return button
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "rate")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(rgb: 0x000000, alpha: 60)
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor(rgb: 0xFFCC22, alpha: 100)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(starImageView)
        addSubview(ratingLabel)
        addSubview(parkButton)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.anchor
        .top(topAnchor)
        .left(leftAnchor)
        
        subtitleLabel.anchor
        .top(titleLabel.bottomAnchor, padding: 4)
        .left(titleLabel.leftAnchor)
        
        starImageView.anchor
        .left(titleLabel.rightAnchor, padding: 8)
        .height(titleLabel.heightAnchor)
        .width(starImageView.heightAnchor)
        
        ratingLabel.anchor
        .left(starImageView.rightAnchor, padding: 8)
        .top(titleLabel.topAnchor)
        .height(titleLabel.heightAnchor)
        
        parkButton.anchor
        .top(subtitleLabel.bottomAnchor, padding: 16)
        .left(leftAnchor)
        .right(rightAnchor)
        .height(parkButton.widthAnchor, multiplier: 0.16)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
