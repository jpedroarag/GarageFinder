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
        let screenWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: (screenWidth/10 - 5), weight: .semibold)
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
        let screenWidth = UIScreen.main.bounds.width
        label.font = .systemFont(ofSize: (screenWidth/10 - 5), weight: .semibold)
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
            .left(leftAnchor, padding: 24, relation: .greaterThanOrEqual)
            .right(timerLabel.leftAnchor, padding: 4)
            .width(constant: 16)
            .height(timerIcon.widthAnchor)
        timerLabel.anchor
            .bottom(bottomAnchor)
            .top(topAnchor)
            .right(centerXAnchor, padding: 16)
        priceIcon.anchor
            .centerY(centerYAnchor)
            .left(centerXAnchor, padding: 16)
            .width(constant: 16)
            .height(timerIcon.widthAnchor)
        priceLabel.anchor
            .left(priceIcon.rightAnchor, padding: -3)
            .bottom(bottomAnchor)
            .top(topAnchor)
            .right(rightAnchor, padding: 24)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }

}
