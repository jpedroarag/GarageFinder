//
//  ParkingWaitingView.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 26/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class ParkingWaitingView: UIView {

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = false
        return indicator
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect  = .zero) {
        super.init(frame: frame)
        addSubviews([loadingIndicator, messageLabel])
        setConstraints()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    private func setConstraints() {
        messageLabel.anchor
            .left(loadingIndicator.rightAnchor, padding: 8)
            .right(rightAnchor, padding: 16)
            .top(topAnchor)
            .height(loadingIndicator.heightAnchor)
        
        loadingIndicator.anchor
            .left(leftAnchor, padding: 16)
            .top(topAnchor)
            .height(constant: 64)
    }
    
    func startWaiting(withMessage message: String) {
        messageLabel.text = message
        loadingIndicator.startAnimating()
    }
    
    func stopWaiting(withNewMessage newMessage: String? = nil, animated: Bool = true) {
        if let message = newMessage {
            messageLabel.text = message
        }
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        replaceConstraints()
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutSubviews()
            }
        } else {
            layoutSubviews()
        }
    }
    
    private func replaceConstraints() {
        loadingIndicator.anchor.width(constant: 0)
//        messageLabel.anchor.deactivateConstraints(withLayoutAttributes: .left)
//        messageLabel.anchor.left(leftAnchor, padding: 8)
    }
    
}
