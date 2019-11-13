//
//  FirstPageViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class PagesIntroViewController: UIViewController {
    let pageView: UIView
    init(withPage: UIView) {
        pageView = withPage
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = pageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
