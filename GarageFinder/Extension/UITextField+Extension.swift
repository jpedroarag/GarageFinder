//
//  UITextField+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UITextField {
    func setStyle() {
        borderStyle = .none
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.textFieldBorderGray.cgColor
        layer.cornerRadius = 5
        clipsToBounds = true
        shadowed()
    }
}
