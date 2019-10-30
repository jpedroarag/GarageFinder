//
//  UINavigationController+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

extension UINavigationController {
    convenience init(rootViewController: UIViewController, int: Int) {
        
        self.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = true
        
        let backArrow = UIImage(named: "back-arrow")?.withRenderingMode(.alwaysOriginal)

        navigationBar.shadowImage = UIImage()
        navigationBar.backIndicatorImage = backArrow
        navigationBar.backIndicatorTransitionMaskImage = backArrow
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        navigationBar.barTintColor = .white
    }
}
