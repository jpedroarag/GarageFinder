//
//  RatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 03/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class RatingViewController: AbstractGarageViewController {

    let ratingView = GarageInfoView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //ratingView.supplementaryView = RatingView()
    }
    
    override func loadView() {
        view = ratingView
    }

}
