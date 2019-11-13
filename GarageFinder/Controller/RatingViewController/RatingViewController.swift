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
            let view = GarageInfoView(collapsed: true, buttonTitle: "Avaliar")
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
        if UserDefaults.tokenIsValid {
            let comment = Comment(fromUserId: UserDefaults.loggedUserId,
                                  toUserId: currentGarage.userId,
                                  garageId: currentGarage.id,
                                  message: ratingView.comment,
                                  rating: Float(ratingView.ratingValue))
            URLSessionProvider().request(.post(comment)) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print("Error posting comment: \(error)")
                }
            }
        } else {
            print("Invalid token")
        }
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
