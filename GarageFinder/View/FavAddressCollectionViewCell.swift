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
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        circleView.backgroundColor = .white
        circleView.shadowed()
        
        //Constraints
        circleView.anchor.attatch(to: self)
        iconImageView.anchor.attatch(to: circleView, paddings: [.top(14), .left(14), .bottom(14), .right(14)])
    }
    
    func loadData(icon: UIImage?) {
        iconImageView.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
