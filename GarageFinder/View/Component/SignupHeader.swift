//
//  SignupHeader.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SignupHeader: UIView {

    lazy var headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .regular)
        title.textColor = .lightBlue
        return title
    }()
    
    lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightBlue
        return separatorView
    }()
    init(frame: CGRect, title: String) {
        super.init(frame: frame)

        backgroundColor = .white
        headerTitle.text = title
        addSubviews([headerTitle, separatorView])
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        headerTitle.anchor
            .centerY(centerYAnchor)
            .left(leftAnchor, padding: 8)
        
        separatorView.anchor
            .top(headerTitle.bottomAnchor, padding: 4)
            .centerX(centerXAnchor)
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .height(constant: 1)
    }
}
