//
//  GFTableViewComponent.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GFTableViewComponent: UIView {
    
    enum ComponentType {
        case garageInfo
        case rating
        case favorite
    }
    
    var type: ComponentType!
    var isCollapsed = false {
        didSet {
            resetConstraints()
            UIView.animate(withDuration: 0.7) {
                self.ratingLabel.font = .systemFont(ofSize: self.isCollapsed ? 15 : 36, weight: .semibold)
                self.layoutSubviews()
            }
        }
    }
    
    lazy var leftImageView: CircleImageView = {
        let view = CircleImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .white
        view.shadowed()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let isRating = (self.type == .rating)
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: isRating ? 9 : 12, weight: isRating ? .bold : .regular)
        label.textColor = UIColor(rgb: isRating ? 0x211414 : 0x000000, alpha: 60)
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: self.isCollapsed ? 15 : 36, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(rgb: 0xFFCE00, alpha: 100)
        return label
    }()
    
    lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "rate")
        return view
    }()
    
    init(type: ComponentType) {
        super.init(frame: .zero)
        self.type = type
        backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.rounded(cornerRadius: leftImageView.bounds.width/2)
    }
    
    private func addSubviews() {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(ratingLabel)
        addSubview(rightImageView)
    }
    
    private func setConstraints() {
        
        var leftPadding: CGFloat = 0
        switch type {
        case .rating: leftPadding = 16
        case .favorite: leftPadding = 8
        default: leftPadding = 0
        }
        
        leftImageView.anchor
            .centerY(centerYAnchor)
            .left(leftAnchor, padding: isCollapsed ? 0 : leftPadding)
            .height(constant: (type == .garageInfo ? 64 : 48))
            .width(constant: isCollapsed ? 0 : (type == .garageInfo ? 64 : 48))
        
        titleLabel.anchor
            .left(leftImageView.rightAnchor, padding: isCollapsed ? 0 : 8)
            .bottom(leftImageView.centerYAnchor)
        
        if !isCollapsed {
            titleLabel.anchor.right(ratingLabel.leftAnchor, padding: 16, relation: .lessThanOrEqual)
        }
        
        subtitleLabel.anchor
            .top(titleLabel.bottomAnchor, padding: 4)
            .left(titleLabel.leftAnchor)
            .right(isCollapsed ? rightAnchor : ratingLabel.leftAnchor, padding: isCollapsed ? 0 : 16, relation: .lessThanOrEqual)
        
        if isCollapsed {
            ratingLabel.anchor
                .left(rightImageView.rightAnchor, padding: 4)
                .top(titleLabel.topAnchor)
        } else {
            ratingLabel.anchor
                .centerY(leftImageView.centerYAnchor)
                .right(rightImageView.leftAnchor, padding: 4)
            if type != .garageInfo {
                ratingLabel.anchor.width(constant: 48)
            }
        }
        
        if isCollapsed {
            rightImageView.anchor
                .left(titleLabel.rightAnchor, padding: 4)
        } else {
            rightImageView.anchor
                .right(rightAnchor, padding: 8)
                .centerY(leftImageView.centerYAnchor)
        }
        
        rightImageView.anchor
            .top(isCollapsed ? titleLabel.topAnchor : topAnchor,
                 padding: isCollapsed ? 0 : 8)
            .width(constant: 12)
        
    }
       
    private func resetConstraints() {
        leftImageView.anchor.deactivateAll()
        titleLabel.anchor.deactivateAll()
        subtitleLabel.anchor.deactivateAll()
        rightImageView.anchor.deactivateAll()
        ratingLabel.anchor.deactivateAll()
        NSLayoutConstraint.deactivate(leftImageView.constraints)
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}
