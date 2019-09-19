//
//  FavoriteAddressCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FavAddressCollectionViewCell: UICollectionViewCell {
    
    let circleView = CircleView()
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleToFill
        return iconImageView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .customDarkGray
        label.text = "Home"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(circleView)
        addSubview(label)
        circleView.addSubview(iconImageView)
        circleView.backgroundColor = .white
        circleView.shadowed()

        setupConstraints()
    }
    
    func setupConstraints() {
        circleView.anchor
            .top(topAnchor)
            .left(leftAnchor)
            .right(rightAnchor)
            .height(constant: 50)
        iconImageView.anchor.attatch(to: circleView, paddings: [.top(14), .left(14), .bottom(14), .right(14)])
        
        label.anchor
            .bottom(bottomAnchor)
            .centerX(centerXAnchor)
    }
    
    func loadData(icon: UIImage?) {
        iconImageView.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
