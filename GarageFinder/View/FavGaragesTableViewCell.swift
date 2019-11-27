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
    
    lazy var component = GFTableViewComponent(type: .favorite)
    var favoriteGarage: Favorite?
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(component)
        setConstraints()
        
        // add shadow on cell and make rounded
        backgroundColor = .clear
        shadowed()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(titleLabel: String?, address: String?, ownerImage: UIImage? = nil) {
        component.titleLabel.text = titleLabel
        component.subtitleLabel.text = address
        component.leftImageView.image = ownerImage
    }
    
    func loadData(_ favoriteGarage: Favorite) {
        self.favoriteGarage = favoriteGarage
        component.titleLabel.text = favoriteGarage.name
        component.subtitleLabel.text = favoriteGarage.address
        
        if let image = favoriteGarage.imageBase64?.base64Convert() {
            component.leftImageView.image = image
            component.leftImageView.contentMode = .scaleAspectFill
        } else {
            component.leftImageView.image = UIImage(named: "profile")
            component.leftImageView.contentMode = .scaleAspectFit
        }
        
        let average = favoriteGarage.average.rounded(toPlaces: 2)
        if average != 0 {
            component.ratingLabel.text = "\(average)"
            return
        }
        component.ratingLabel.text = "S/A"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
    }
        
    func setConstraints() {
        component.anchor
            .top(topAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 8, priority: 999)
            .left(leftAnchor, padding: 16)
            .width(constant: 50)
            .height(constant: 50)
            .right(rightAnchor, padding: 16)
    }

}
