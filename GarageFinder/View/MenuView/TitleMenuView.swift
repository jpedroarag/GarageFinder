//
//  TitleMenuView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TitleMenuView: UIView {
    lazy var photoShadowView: UIView = {
        let view = UIView()
        view.shadowed()
        view.backgroundColor = .white
        view.layer.cornerRadius = 42
        return view
    }()
    
    lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView(image: UIImage(named: "profile"))
        photoImageView.contentMode = .center
        photoImageView.backgroundColor = .white
        photoImageView.layer.cornerRadius = 42
        photoImageView.clipsToBounds = true
        return photoImageView
    }()
    
//    lazy var nameLabel: UILabel = {
//        let name = UILabel()
//        name.font = .systemFont(ofSize: 22, weight: .regular)
//        name.text = "João Paulo"
//        return name
//    }()
    
    override func didMoveToSuperview() {
        addSubviews([photoShadowView, photoImageView])
        setupConstraints()
    }
    
    func setupConstraints() {
        photoShadowView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .width(constant: 84)
            .height(constant: 84)
        
        photoImageView.anchor
            .top(safeAreaLayoutGuide.topAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .width(constant: 84)
            .height(constant: 84)
        
    }
}
