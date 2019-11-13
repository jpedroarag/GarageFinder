//
//  ThirdPageIntroView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class ThirdPageIntroView: UIView {
    var action: (() -> Void)?
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.shadowed()
        contentView.layer.cornerRadius = 5
        return contentView
    }()
    
    lazy var finishButton: GFButton = {
        let button = GFButton()
        button.setTitle("Começar", for: .normal)
        return button
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .customDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
                     Tudo pronto para você usar o Garage Finder :)
                     """
        return label
    }()
    
    lazy var greetingsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .customDarkGray
        label.text = ""
        return label
    }()
    override func didMoveToSuperview() {
        backgroundColor = .init(rgb: 0x019231, alpha: 100)
        addSubviews([contentView, finishButton])
        contentView.addSubviews([infoLabel, greetingsLabel])
        setupConstraints()
        
        finishButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
    }
    
    @objc func startAction() {
        action?()
    }
    
    func setupConstraints() {
        contentView.anchor
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .centerY(safeAreaLayoutGuide.centerYAnchor, padding: -50)
            .height(heightAnchor, multiplier: 0.6)
        
        finishButton.anchor
            .bottom(safeAreaLayoutGuide.bottomAnchor, padding: 32)
            .left(safeAreaLayoutGuide.leftAnchor, padding: 16)
            .right(safeAreaLayoutGuide.rightAnchor, padding: 16)
            .height(constant: 60)
        
        infoLabel.anchor
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .centerY(contentView.centerYAnchor, padding: -40)
        
        greetingsLabel.anchor
            .left(contentView.leftAnchor, padding: 16)
            .right(contentView.rightAnchor, padding: 16)
            .bottom(contentView.bottomAnchor, padding: 40)
        
    }
}
