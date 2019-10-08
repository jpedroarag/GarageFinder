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
    var currentGarage = Garage()
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: true)
            view.button.setTitle("Avaliar", for: .normal)
            view.button.action = ratingAction(_:)
            view.addSupplementaryView(ratingView, animated: false, nil)
            view.loadData(currentGarage)
            self.mutableGarageInfoView = view
            return view
        }
    }
    
    func ratingAction (_ button: GFButton) {
        print("Rating comment: \(ratingView.commentTextView.text ?? "")")
    }
    
    override func viewDidLoad() {
        shouldAppearAnimated = false
        numberOfSections = 1
        sectionSeparatorsStartAppearIndex = 1
        super.viewDidLoad()
        
        view.addGestureRecognizer(view.tap)
    }
    
    override func sectionContent(forIndexPath indexPath: IndexPath) -> UIView? {
        switch indexPath.section {
        case 0: return garageInfoView
        default: return nil
        }
    }
}
