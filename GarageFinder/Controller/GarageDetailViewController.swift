//
//  GarageDetailViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 05/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageDetailViewController: UIViewController {

    let closeButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.text = "X"
        button.backgroundColor = .green
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        print("garage detail loaded")
        
        view.addSubview(closeButton)
        
        closeButton.anchor
        .top(view.topAnchor)
        .right(view.rightAnchor)
        .width(constant: 25)
        .height(constant: 25)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        print("closebuttonTapped")
        removeFromParent()
        view.removeFromSuperview()
    }
}
