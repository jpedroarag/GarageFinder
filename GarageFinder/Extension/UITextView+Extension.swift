//
//  UITextField+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UITextView {
    convenience init(fontSize: CGFloat) {
        
        self.init()
        backgroundColor = .white
        layer.borderColor = UIColor.textFieldBorderGray.cgColor
        layer.cornerRadius = 5
        font = .systemFont(ofSize: fontSize)
    }
}
