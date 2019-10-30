//
//  LoadingView.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 24/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class LoadingView: UIView {
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    lazy var loadingIndicator = UIActivityIndicatorView()
    
    init(message: String) {
        super.init(frame: CGRect.zero)
        messageLabel.text = message
        
        alpha = 0
        backgroundColor = .customGreen
        loadingIndicator.color = .white
        shadowed()
        layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        addSubviews([messageLabel, loadingIndicator])
        setupConstraints()
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        loadingIndicator.startAnimating()
    }
    
    func setupConstraints() {
        if let superView = self.superview {
            anchor
                .top(superView.safeAreaLayoutGuide.topAnchor, padding: 16)
                .width(constant: 200)
                .centerX(superView.centerXAnchor)
                .height(constant: 30)
            
            messageLabel.anchor
                .centerY(centerYAnchor)
                .left(leftAnchor, padding: 16)
            
            loadingIndicator.anchor
                .centerY(centerYAnchor)
                .right(rightAnchor, padding: 16)
                .width(constant: 20)
                .height(constant: 20)
        }
    }

    func dismissIndicator(animated: Bool = true) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
