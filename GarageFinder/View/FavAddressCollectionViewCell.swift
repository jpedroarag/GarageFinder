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
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(circleView)
        circleView.backgroundColor = .white
        circleView.shadowed()
        circleView.anchor.attatch(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
