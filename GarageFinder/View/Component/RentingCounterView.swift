//
//  RentingCounterView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class RentingCounterView: UIView {

    lazy var timerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 36.0, weight: .semibold)
        label.text = "00:00"
        return label
    }()
    
    lazy var timerIcon: UIImageView = {
        let icon = UIImageView(frame: .zero)
        icon.image = UIImage(named: "clock")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 36.0, weight: .semibold)
        label.text = " 0,00"
        return label
    }()
    
    lazy var priceIcon: UIImageView = {
        let icon = UIImageView(frame: .zero)
        icon.image = UIImage(named: "dollarSign")
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timerIcon)
        addSubview(timerLabel)
        addSubview(priceIcon)
        addSubview(priceLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        timerIcon.anchor
            .centerY(centerYAnchor)
            .left(leftAnchor, padding: 24, relation: .lessThanOrEqual)
            .width(constant: 16)
            .height(timerIcon.widthAnchor)
        timerLabel.anchor
            .bottom(bottomAnchor)
            .top(topAnchor)
            .left(timerIcon.rightAnchor, padding: 4)
        priceIcon.anchor
            .centerY(centerYAnchor)
            .right(priceLabel.leftAnchor, padding: -3)
            .width(constant: 16)
            .height(timerIcon.widthAnchor)
        priceLabel.anchor
            .bottom(bottomAnchor)
            .top(topAnchor)
            .right(rightAnchor, padding: 24, relation: .lessThanOrEqual)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
