//
//  GarageDetailViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 05/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageDetailsViewController: UIViewController {

    let closeButton: UIButton = {
       let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .gray
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        print("garage detail loaded")
        
        view.addSubview(closeButton)
        
        closeButton.anchor
        .top(view.topAnchor, padding: 16)
        .right(view.rightAnchor, padding: 16)
        .width(constant: 25)
        .height(constant: 25)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: 0, y: 0,
                                         width: self.view.frame.width,
                                         height: self.view.frame.height)
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func closeButtonTapped() {
        removeFromParent()
        view.removeFromSuperview()
    }
}
