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
    
    var heartImageView: UIImageView
    
    lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .customLightGray
        return separatorView
    }()
    init(frame: CGRect, title: String, image: UIImage? = nil) {
        heartImageView = UIImageView(image: image)
        super.init(frame: frame)
        backgroundColor = .white
        setupHeaderTitle(text: title)
        setupSeparatorView()
        if image != nil {
            setupImageView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        addSubview(heartImageView)
        heartImageView.anchor
            .centerY(centerYAnchor)
            .left(headerTitle.rightAnchor)
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
