//
//  GFTableViewComponent.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GFTableViewComponent: UIView {
    
    let leftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(rgb: 0x211414, alpha: 60)
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.textColor = UIColor(rgb: 0xFFCE00, alpha: 100)
        return label
    }()
    
    let rightImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "rate")
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
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
        addSubview(rightLabel)
        addSubview(rightImageView)
    }
    
    private func setConstraints() {
        leftImageView.anchor
            .top(topAnchor, padding: 8)
            .left(leftAnchor, padding: 16)
            .height(heightAnchor, constant: -12)
            .width(leftImageView.heightAnchor)
        
        titleLabel.anchor
            .bottom(leftImageView.centerYAnchor)
            .left(leftImageView.rightAnchor, padding: 16)
            .right(rightLabel.leftAnchor, padding: 16)
        
        subtitleLabel.anchor
            .top(titleLabel.bottomAnchor, padding: 4)
            .left(titleLabel.leftAnchor)
            .right(titleLabel.rightAnchor)
        
        rightLabel.anchor
            .right(rightImageView.leftAnchor, padding: 4)
            .centerY(leftImageView.centerYAnchor)
        
        rightImageView.anchor
            .top(topAnchor, padding: 8)
            .right(rightAnchor, padding: 8)
            .centerY(leftImageView.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) { return nil }
    
}
