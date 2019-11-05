//
//  MainIntroView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class MainIntroView: UIView {
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.shadowed()
        contentView.layer.cornerRadius = 5
        return contentView
    }()

    override func didMoveToSuperview() {
        backgroundColor = .init(rgb: 0x019231, alpha: 100)
        addSubview(contentView)
        setupConstraints()
    }
    
    func setupConstraints() {
        contentView.anchor
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .centerY(safeAreaLayoutGuide.centerYAnchor)
            .height(heightAnchor, multiplier: 0.6)
    }
}
