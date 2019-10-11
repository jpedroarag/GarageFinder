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
}
