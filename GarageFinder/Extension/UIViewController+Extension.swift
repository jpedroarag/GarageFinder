//
//  UIViewController+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(_ vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}
