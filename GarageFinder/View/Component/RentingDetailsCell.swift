//
//  RentingDetailsCell.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class RentingDetailsCell: UITableViewCell {
    lazy var leftLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var rightLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(iconImageView)
        setConstraints()
        rounded(cornerRadius: 5)
    }
    
    private func setConstraints() {
        leftLabel.anchor
            .top(topAnchor, padding: 8)
            .left(leftAnchor, padding: 8)
            .bottom(bottomAnchor, padding: 8)
        
        switch reuseIdentifier {
        case "rentingDetailsPriceCell":
            iconImageView.anchor
                .right(rightLabel.leftAnchor)
                .centerY(centerYAnchor)
                .height(constant: 16)
                .width(iconImageView.heightAnchor)
            rightLabel.anchor
                .top(topAnchor, padding: 8)
                .right(rightAnchor, padding: 8)
                .bottom(bottomAnchor, padding: 8)
        case "rentingDetailsTimeCell":
            rightLabel.anchor
                .top(topAnchor, padding: 8)
                .right(iconImageView.leftAnchor, padding: 8)
                .bottom(bottomAnchor, padding: 8)
            iconImageView.anchor
                .right(rightAnchor, padding: 8)
                .centerY(centerYAnchor)
                .height(constant: 8)
                .width(iconImageView.heightAnchor)
        default: return
        }
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
}
