//
//  SecondPageIntroView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SecondPageIntroView: UIView {
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.shadowed()
        contentView.layer.cornerRadius = 5
        return contentView
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "hourGlass"))
        imgView.shadowed()
        imgView.contentMode = .scaleAspectFit
        contentView.layer.cornerRadius = 5
        return imgView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .customDarkGray
        label.textAlignment = .center
        label.text = "Pague somente o tempo que utilizar"
        return label
    }()
    
    override func didMoveToSuperview() {
        backgroundColor = .init(rgb: 0x019231, alpha: 100)
        addSubview(contentView)
        contentView.addSubviews([imageView, infoLabel])
        setupConstraints()
    }

    func setupConstraints() {
        contentView.anchor
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .centerY(safeAreaLayoutGuide.centerYAnchor, padding: -50)
            .height(heightAnchor, multiplier: 0.6)
        
        imageView.anchor
            .centerY(contentView.centerYAnchor, padding: -40)
            .centerX(contentView.centerXAnchor)
            .height(contentView.heightAnchor, multiplier: 0.3)
            .width(imageView.heightAnchor, multiplier: 0.7)
        
        infoLabel.anchor
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .bottom(contentView.bottomAnchor, padding: 40)
    }
}
