//
//  LabelCell.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    var type: TextFieldType?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .lightBlue
        return label
    }()
    
    lazy var label: UITextField = {
        let label = UITextField()
        label.isUserInteractionEnabled = false
        label.text = "------"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([titleLabel, label])
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
        titleLabel.anchor
            .top(topAnchor, padding: 8)
            .left(leftAnchor, padding: 8)
            
        label.anchor
            .top(titleLabel.topAnchor, padding: 16)
            .left(leftAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 16)
    }
    
    func setType(_ type: TextFieldType) {
        self.type = type
        titleLabel.text = type.rawValue
        
        switch type {
        case .password:
            label.isSecureTextEntry = true
        case .email, .driverLicense, .model, .year, .chassi, .licensePlate:
            label.textColor = .lightGray
        default: break
        }
    }
}
