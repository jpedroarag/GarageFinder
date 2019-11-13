//
//  GarageActionsView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 12/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageActionsView: UIView {

    lazy var likeButton: CircularButton = {
        let icon = UIImage(named: "HeartIconUnfilled")
        return CircularButton(icon: icon, size: 48)
    }()
    
    lazy var rateButton: CircularButton = {
        let icon = UIImage(named: "rate")
        return CircularButton(icon: icon, size: 48)
    }()
    
    lazy var shareButton: CircularButton = {
        let icon = UIImage(named: "share")
        return CircularButton(icon: icon, size: 48)
    }()
    
    lazy var reportButton: CircularButton = {
        let icon = UIImage(named: "report")
        return CircularButton(icon: icon, size: 48)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        addSubview(likeButton)
        
        rateButton.addTarget(self, action: #selector(rateButtonTapped(_:)), for: .touchUpInside)
        addSubview(rateButton)
        
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        addSubview(shareButton)
        
        reportButton.addTarget(self, action: #selector(reportButtonTapped(_:)), for: .touchUpInside)
        addSubview(reportButton)
        
        setConstraints()
    }
    
    convenience init(likeButtonFilled: Bool = false) {
        self.init(frame: .zero)
        if likeButtonFilled {
            switchLikeIcon()
        }
    }
    
    private func setConstraints() {
        let buttonsWidth: CGFloat = 48
        let contentWidth = 4 * buttonsWidth
        let width = UIScreen.main.bounds.width - (64 + 16)
        let emptySpace = width - contentWidth
        
        likeButton.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 32)
            .width(constant: buttonsWidth)
            .height(constant: buttonsWidth)
        rateButton.anchor
            .top(topAnchor)
            .left(likeButton.rightAnchor, padding: emptySpace/3)
            .width(likeButton.widthAnchor)
            .height(likeButton.heightAnchor)
        shareButton.anchor
            .top(topAnchor)
            .right(reportButton.leftAnchor, padding: emptySpace/3)
            .width(likeButton.widthAnchor)
            .height(likeButton.heightAnchor)
        reportButton.anchor
            .top(topAnchor)
            .right(rightAnchor, padding: 32)
            .width(likeButton.widthAnchor)
            .height(likeButton.heightAnchor)
    }
    
    private func switchLikeIcon() {
        let image = UIImage(named: "HeartIconUnfilled")
        if likeButton.image(for: .normal) == image {
            likeButton.setImage(UIImage(named: "HeartIcon"), for: .normal)
        } else {
            likeButton.setImage(image, for: .normal)
        }
    }
    
    @objc private func likeButtonTapped(_ sender: CircularButton) {
        likeButton.action?(sender)
        switchLikeIcon()
    }
    
    @objc private func rateButtonTapped(_ sender: CircularButton) {
        rateButton.action?(sender)
    }
    
    @objc private func shareButtonTapped(_ sender: CircularButton) {
        shareButton.action?(sender)
    }
    
    @objc private func reportButtonTapped(_ sender: CircularButton) {
        reportButton.action?(sender)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}
