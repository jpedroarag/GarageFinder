//
//  FavoritesTableViewCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class FavGaragesTableViewCell: UITableViewCell {

    lazy var boxView = UIView()
    
    lazy var component = GFTableViewComponent(type: .rating)
    
    lazy var garageOwnerImage: CircleImageView = {
        let image = CircleImageView()
        let shadowImage = CircleView()
        shadowImage.shadowed()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var garageTitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.3"
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .customYellow
        return label
    }()
    
    lazy var starImage = UIImageView(image: UIImage(named: "star"))
    
    var favoriteGarage: Favorite?
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(garageOwnerImage)
        addSubview(boxView)
        boxView.addSubview(garageTitleLabel)
        boxView.addSubview(addressLabel)
        addSubview(ratingLabel)
        addSubview(starImage)
        setConstraintsa()
        
        // add shadow on cell and make rounded
        backgroundColor = .clear
        shadowed()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(titleLabel: String?, address: String?, ownerImage: UIImage? = nil) {
        garageTitleLabel.text = titleLabel
        addressLabel.text = address
        garageOwnerImage.image = ownerImage
    }
    func loadData(_ favoriteGarage: Favorite) {
        self.favoriteGarage = favoriteGarage
        garageTitleLabel.text = favoriteGarage.name
        addressLabel.text = favoriteGarage.address
        garageOwnerImage.image = UIImage(named: "mockPerson")
        ratingLabel.text = "\(favoriteGarage.average)"
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
    }
    
    func setConstraints() {
        garageOwnerImage.anchor
            .top(topAnchor, padding: 12)
            .bottom(bottomAnchor, padding: 12, priority: 999)
            .left(leftAnchor, padding: 24)
            .width(constant: 50)
            .height(constant: 50)
        
        boxView.anchor
            .top(topAnchor, padding: 22)
            .left(garageOwnerImage.rightAnchor, padding: 24)
            .right(ratingLabel.leftAnchor, padding: 24)
            .bottom(bottomAnchor, padding: 22)
        
        garageTitleLabel.anchor
            .top(boxView.topAnchor)
            .left(boxView.leftAnchor)
            
        addressLabel.anchor
            .left(boxView.leftAnchor)
            .bottom(boxView.bottomAnchor)

        ratingLabel.anchor
            .right(starImage.leftAnchor)
            .bottom(bottomAnchor, padding: 16)
        
        starImage.anchor
            .centerY(centerYAnchor, padding: 7)
            .right(rightAnchor, padding: 16)
    }
    
    func setConstraintsa() {
        garageOwnerImage.anchor
            .top(topAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 8, priority: 999)
            .left(leftAnchor, padding: 16)
            .width(constant: 50)
            .height(constant: 50)
        
        boxView.anchor
            .top(topAnchor, padding: 16)
            .left(garageOwnerImage.rightAnchor, padding: 16)
            .right(ratingLabel.leftAnchor, padding: 16)
            .bottom(bottomAnchor, padding: 16)
        
        garageTitleLabel.anchor
            .top(boxView.topAnchor)
            .left(boxView.leftAnchor)
            
        addressLabel.anchor
            .left(boxView.leftAnchor)
            .top(garageTitleLabel.bottomAnchor)

        ratingLabel.anchor
            .right(starImage.leftAnchor, padding: 4)
            .centerY(garageOwnerImage.centerYAnchor)
        
        starImage.anchor
            .centerY(centerYAnchor)
            .right(rightAnchor, padding: 16)
    }

}
