//
//  HeaderFavTableView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 18/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class HeaderFavTableView: UIView {

    lazy var headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .medium)
        title.textColor = .customDarkGray
        return title
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleToFill
        return iconImageView
    }()
    
    lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .customLightGray
        return separatorView
    }()
    init(frame: CGRect, title: String, image: UIImage? = nil) {
        super.init(frame: frame)

        backgroundColor = .white
        setupHeaderTitle(text: title)
        setupSeparatorView()
        if let image = image {
            setupImageView(image: image)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView(image: UIImage) {
        iconImageView.image = image
        addSubview(iconImageView)
        iconImageView.anchor
            .centerY(centerYAnchor)
            .left(headerTitle.rightAnchor, padding: 8)
            .height(constant: 14)
            .width(iconImageView.heightAnchor, multiplier: 1.1)
    }
    func setupHeaderTitle(text: String) {
        headerTitle.text = text
        addSubview(headerTitle)
        headerTitle.anchor
            .centerY(centerYAnchor)
            .left(leftAnchor, padding: 8)
    }
    
    func setupSeparatorView() {
        addSubview(separatorView)
        separatorView.anchor
            .top(topAnchor)
            .centerX(centerXAnchor)
            .width(widthAnchor, multiplier: 0.712)
            .height(constant: 1)
    }
    
}
