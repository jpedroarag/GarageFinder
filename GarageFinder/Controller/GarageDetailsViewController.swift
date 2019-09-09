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
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        view.addSubview(closeButton)
        view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        setConstraints()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: 0, y: 0,
                                         width: self.view.frame.width,
                                         height: self.view.frame.height)
            })
        }
    }
    
    private func setConstraints() {
        closeButton.anchor
        .top(view.topAnchor, padding: 16)
        .right(view.rightAnchor, padding: 16)
        .width(constant: 30)
        .height(constant: 30)
//
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
}
