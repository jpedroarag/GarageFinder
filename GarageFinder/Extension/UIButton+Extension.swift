//
//  UIButton+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIButton {
    func setImage(_ named: String) {
        setBackgroundImage(UIImage(named: named), for: .normal)
    }
    
    convenience init(circularWith img: UIImage?, andCornerRadius cornerRadius: CGFloat) {
        self.init()
        setImage(img, for: .normal)
        contentMode = .center
        imageView?.contentMode = .center
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = .white
        shadowed()
    }
    
    convenience init(withTitle: String) {
        self.init()
        setTitle(withTitle, for: .normal)
        setTitleColor(.black, for: .normal)
    }
}
