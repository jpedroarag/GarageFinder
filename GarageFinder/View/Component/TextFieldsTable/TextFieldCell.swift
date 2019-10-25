//
//  TextFieldCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    private var type: TextFieldType?

    lazy var textField: GFTextField = {
        let textField = GFTextField(withType: .none)
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(textField)
        self.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setUpConstraint()
    }
    
    private func setUpConstraint() {
        textField.anchor
            .top(topAnchor, padding: 16)
            .right(rightAnchor)
            .left(leftAnchor)
            .bottom(bottomAnchor)
    }
}
