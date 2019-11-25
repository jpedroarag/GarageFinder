//
//  OptionSelectorCollectionViewCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 21/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class OptionSelectorCollectionViewCell: UICollectionViewCell {
    lazy var label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                select()
            } else {
                unselect()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        setConstraints()
        unselect()
        rounded(cornerRadius: 5)
    }
    
    private func setConstraints() {
        label.anchor
            .centerX(centerXAnchor)
            .centerY(centerYAnchor)
            .width(constant: 96)
            .height(constant: 48)
    }
    
    func select() {
        backgroundColor = .customDarkGray
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    func unselect() {
        backgroundColor = UIColor(rgb: 0xBBBBBB, alpha: 100)
        label.textColor = .customDarkGray
        label.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    required init?(coder: NSCoder) { return nil }
}
