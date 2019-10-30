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
    
    func setNavigationCloseButton() {
        let rightButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(dismissVC))
        rightButton.image = UIImage(named: "close2")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func dismissVC() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
