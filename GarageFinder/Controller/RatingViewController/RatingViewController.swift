//
//  RatingViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 03/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class RatingViewController: AbstractGarageViewController {

    lazy var ratingView = RatingView()
    var currentGarage: Garage!
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: true)
            view.button.setTitle("Avaliar", for: .normal)
            view.addSupplementaryView(ratingView, animated: true, nil)
            view.button.action = ratingAction(_:)
            view.loadData(currentGarage)
            self.mutableGarageInfoView = view
            return view
        }
    }
    
    func ratingAction (_ button: GFButton) {
        ratingView.commentTextView.endEditing(true)
        print("Rating: \(ratingView.ratingValue), Comment: \(ratingView.comment ?? "")")
        dismissFromParent()
    }
    
    override func viewDidLoad() {
        shouldAppearAnimated = false
        numberOfSections = 1
        sectionSeparatorsStartAppearIndex = 1
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
