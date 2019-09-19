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
        let icon = UIImage(named: "like")
        let width = 0.128 * UIScreen.main.bounds.width
        return CircularButton(icon: icon, size: width)
    }()
    
    lazy var rateButton: CircularButton = {
        let icon = UIImage(named: "rate")
        let width = 0.128 * UIScreen.main.bounds.width
        return CircularButton(icon: icon, size: width)
    }()
    
    lazy var shareButton: CircularButton = {
        let icon = UIImage(named: "share")
        let width = 0.128 * UIScreen.main.bounds.width
        return CircularButton(icon: icon, size: width)
    }()
    
    lazy var reportButton: CircularButton = {
        let icon = UIImage(named: "report")
        let width = 0.128 * UIScreen.main.bounds.width
        return CircularButton(icon: icon, size: width)
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
    
    private func setConstraints() {
        let ratio: CGFloat = 0.128
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let buttonsWidth = ratio * screenWidth
        let contentWidth = 4 * buttonsWidth
        let width = UIScreen.main.bounds.width - (64 + 16)
        let emptySpace = width - contentWidth
        
        likeButton.anchor
            .top(topAnchor)
            .left(leftAnchor, padding: 32)
            .width(constant: buttonsWidth)
            .height(likeButton.widthAnchor)
        rateButton.anchor
            .top(topAnchor)
            .left(likeButton.rightAnchor, padding: emptySpace/3)
            .width(constant: buttonsWidth)
            .height(rateButton.widthAnchor)
        shareButton.anchor
            .top(topAnchor)
            .right(reportButton.leftAnchor, padding: emptySpace/3)
            .width(constant: buttonsWidth)
            .height(shareButton.widthAnchor)
        reportButton.anchor
            .top(topAnchor)
            .right(rightAnchor, padding: 32)
            .width(constant: buttonsWidth)
            .height(reportButton.widthAnchor)
    }
    
    @objc private func likeButtonTapped(_ sender: CircularButton) {
        likeButton.action?(sender)
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
