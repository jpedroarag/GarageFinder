//
//  TextFieldCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    var type: TextFieldType?

    lazy var textField: GFTextField = {
        let textField = GFTextField(withType: .none)
        textField.attributedPlaceholder = NSAttributedString(string: "placeholder text", attributes: [.foregroundColor: UIColor.lightBlue])
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        backgroundColor = .white
        selectionStyle = .none
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setUpConstraint()
    }
    
    private func setUpConstraint() {
        textField.anchor
            .top(topAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .left(leftAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 8)
    }
}
