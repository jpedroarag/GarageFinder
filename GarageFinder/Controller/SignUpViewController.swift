//
//  SignUpViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 23/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class SignUpViewController: UIViewController {
    let sigUpView: SignUpView
    let isEditingProfile: Bool
    
    init(isEditingProfile: Bool = false) {
        self.isEditingProfile = isEditingProfile
        self.sigUpView = SignUpView(isEditingProfile: isEditingProfile)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view = sigUpView
    }
}
