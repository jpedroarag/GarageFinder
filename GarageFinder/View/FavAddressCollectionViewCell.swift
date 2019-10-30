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
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.textColor = .customDarkGray
        return label
    }()
    
    var favoriteAddress: Favorite?
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
            .width(widthAnchor)
    }
    
    func loadData(favoriteAddress: Favorite) {
        self.favoriteAddress = favoriteAddress
        label.text = favoriteAddress.name
        iconImageView.image = favoriteAddress.category?.icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
