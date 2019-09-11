//
//  UIView+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 10/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIView {
    func shadowed(color: UIColor = .black,
                  opacity: Float = 0.15,
                  offset: CGSize = CGSize(width: 0, height: 2),
                  radius: CGFloat = 3) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
    }
    
    func rounded(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

}
