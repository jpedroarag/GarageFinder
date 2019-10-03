//
//  UIStackView+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 26/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
