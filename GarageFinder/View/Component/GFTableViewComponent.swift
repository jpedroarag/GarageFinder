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
    }
    
    var type: ComponentType!
    var isCollapsed = false {
        didSet {
            resetConstraints()
            self.ratingLabel.alpha = 0
            UIView.animate(withDuration: 0.7) {
                self.ratingLabel.font = .systemFont(ofSize: self.isCollapsed ? 15 : 36, weight: .semibold)
                self.layoutSubviews()
                UIView.animate(withDuration: 0.35) {
                    self.ratingLabel.alpha = 1
                }
            }
        }
    }
    
    lazy var leftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
        label.textColor = UIColor(rgb: 0xFFCE00, alpha: 100)
        return label
    }()
    
    lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "rate")
        return view
    }()
    
    var leftImageViewLeftConstraint: NSLayoutConstraint!
    var leftImageViewWidthConstraint: NSLayoutConstraint!
    var titleLabelLeftConstraint: NSLayoutConstraint!
    var titleLabelWidthConstraint: NSLayoutConstraint!
    var ratingLabelCenterYConstraint: NSLayoutConstraint!
    var ratingLabelTopConstraint: NSLayoutConstraint!
    var ratingLabelRightConstraint: NSLayoutConstraint!
    var ratingLabelLeftConstraint: NSLayoutConstraint!
    var rightImageViewTopConstraint: NSLayoutConstraint!
    var rightImageViewRightConstraint: NSLayoutConstraint!
    var rightImageViewCenterYConstraint: NSLayoutConstraint!
    var rightImageViewLeftConstraint: NSLayoutConstraint!
    
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
        let leftImageViewInsets: (left: CGFloat, right: CGFloat) = !isCollapsed ? (16, 16) : (0, 8)
        let ratingsSectionInsets: (left: CGFloat, right: CGFloat) = !isCollapsed ? (8, 8) : (4, 4)
        let filledSpace = leftImageViewInsets.left
                        + leftImageViewInsets.right
                        + ratingsSectionInsets.left
                        + ratingsSectionInsets.right
                        + leftImageView.bounds.width
                        + ratingLabel.bounds.width
                        + rightImageView.bounds.width
        titleLabelWidthConstraint.constant = -filledSpace
        titleLabelWidthConstraint.isActive = !isCollapsed
    }
    
    private func addSubviews() {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(ratingLabel)
        addSubview(rightImageView)
    }
    
    private func setUnmutableConstraints() {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        leftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        leftImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: (type == .rating) ? -12 : 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: leftImageView.centerYAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
    }
    
    private func setConstraints() {
        setUnmutableConstraints()
        titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
        if !isCollapsed {
            leftImageViewLeftConstraint = leftImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: (type == .rating) ? 16 : 0) //
            leftImageViewLeftConstraint.isActive = true
            
            leftImageViewWidthConstraint = leftImageView.widthAnchor.constraint(equalTo: leftImageView.heightAnchor) //
            leftImageViewWidthConstraint.isActive = true
            
            titleLabelLeftConstraint = titleLabel.leftAnchor.constraint(equalTo: leftImageView.rightAnchor, constant: (type == .rating) ? 16 : 8) //
            titleLabelLeftConstraint.isActive = true
            
            ratingLabelCenterYConstraint = ratingLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor) ///
            ratingLabelCenterYConstraint.isActive = true
            
            ratingLabelRightConstraint = ratingLabel.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -4) ///
            ratingLabelRightConstraint.isActive = true
            
            rightImageViewTopConstraint = rightImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8) //
            rightImageViewTopConstraint.isActive = true
            
            rightImageViewRightConstraint = rightImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8) ///
            rightImageViewRightConstraint.isActive = true
            
            rightImageViewCenterYConstraint = rightImageView.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor) ///
            rightImageViewCenterYConstraint.isActive = true
        } else {
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
            ratingLabel.leftAnchor.constraint(equalTo: rightImageView.rightAnchor, constant: 4).isActive = true
            rightImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4).isActive = true
        }
    }
    
    private func replaceConstraintsWhenExpanding() {
        if !isCollapsed {
            rightImageViewTopConstraint.isActive = false
            rightImageViewTopConstraint = rightImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8)
            rightImageViewTopConstraint.isActive = true
            
            if let constraint = ratingLabelLeftConstraint { constraint.isActive = false }
            if let constraint = ratingLabelTopConstraint { constraint.isActive = false }
            if let constraint = rightImageViewLeftConstraint { constraint.isActive = false }
            
            if let constraint = ratingLabelCenterYConstraint {
                constraint.isActive = true
            } else {
                ratingLabelCenterYConstraint = ratingLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor)
                ratingLabelLeftConstraint.isActive = true
            }
            
            if let constraint = ratingLabelRightConstraint {
                constraint.isActive = true
            } else {
                ratingLabelRightConstraint = ratingLabel.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -4)
                ratingLabelLeftConstraint.isActive = true
            }
            
            if let constraint = rightImageViewRightConstraint {
                constraint.isActive = true
            } else {
                rightImageViewRightConstraint = rightImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
                ratingLabelLeftConstraint.isActive = true
            }
            
            if let constraint = rightImageViewCenterYConstraint {
                constraint.isActive = true
            } else {
                rightImageViewCenterYConstraint = rightImageView.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor)
                ratingLabelLeftConstraint.isActive = true
            }
        }
    }
    
    private func replaceConstraintsWhenCollapsing() {
        if isCollapsed {
            rightImageViewTopConstraint.isActive = false
            rightImageViewTopConstraint = rightImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor)
            rightImageViewTopConstraint.isActive = true
            
            if let constraint = ratingLabelCenterYConstraint { constraint.isActive = false }
            if let constraint = ratingLabelRightConstraint { constraint.isActive = false }
            
            if let constraint = ratingLabelLeftConstraint {
                constraint.isActive = true
            } else {
                ratingLabelLeftConstraint = ratingLabel.leftAnchor.constraint(equalTo: rightImageView.rightAnchor, constant: 4)
                ratingLabelLeftConstraint.isActive = true
            }
            
            if let constraint = ratingLabelTopConstraint {
                constraint.isActive = true
            } else {
                ratingLabelTopConstraint = ratingLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor)
                ratingLabelTopConstraint.isActive = true
            }
            
            if let constraint = rightImageViewRightConstraint { constraint.isActive = false }
            if let constraint = rightImageViewCenterYConstraint { constraint.isActive = false }
            
            if let constraint = rightImageViewLeftConstraint {
                constraint.isActive = true
            } else {
                rightImageViewLeftConstraint = rightImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4)
                rightImageViewLeftConstraint.isActive = true
            }
        }
    }
    
    private func resetConstraints() {
        if !isCollapsed { // Collapsed -> Expanded
            leftImageViewLeftConstraint.constant = (type == .rating) ? 16 : 0
            leftImageViewWidthConstraint.constant = 0
            titleLabelLeftConstraint.constant = (type == .rating) ? 16 : 8
            replaceConstraintsWhenExpanding()
        } else { // Expanded -> Collapsed
            leftImageViewLeftConstraint.constant = 0
            leftImageViewWidthConstraint.constant = -leftImageView.bounds.height
            titleLabelLeftConstraint.constant = 0
            replaceConstraintsWhenCollapsing()
        }
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}
