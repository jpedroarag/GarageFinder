//
//  UIView+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(withImage: UIImage?) {
        self.init()
        let imageView = UIImageView(image: withImage)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        imageView.anchor
            .top(topAnchor, padding: 32)
            .left(leftAnchor, padding: 32)
            .right(rightAnchor, padding: 32)
            .bottom(bottomAnchor, padding: 32)
    }

    func shadowed(color: UIColor = .black,
                  opacity: Float = 0.2,
                  offset: CGSize = CGSize(width: 0, height: 2),
                  radius: CGFloat = 3) {

        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func rounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}

extension UIView {
    var tap: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
