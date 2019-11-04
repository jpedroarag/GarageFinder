//
//  UserTestFeedbackViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class UserTestFeedbackViewController: UIViewController {
    
    lazy var mainView = UserTestFeedbackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dismissButton.action = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        view = mainView
    }

}
