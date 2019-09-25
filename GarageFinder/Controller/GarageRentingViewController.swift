
//
//  GarageRentingViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageRentingViewController: AbstractGarageViewController {

    override func viewDidLoad() {
        shouldAppearAnimated = false
        numberOfSections = 1
        indexSectionSeparatorsShouldStartAppearing = 1
        super.viewDidLoad()
        garageInfoView.component.isCollapsed = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if numberOfSections == 1 {
            numberOfSections += 1
            tableView.insertSections([1], with: .fade)
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate implement
extension GarageRentingViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Detalhes"
        default: return nil
        }
    }
    
    override func sectionContent(forIndexPath indexPath: IndexPath) -> UIView? {
        switch indexPath.section {
        case 0: return garageInfoView
        case 1: return nil
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        switch indexPath.section {
        case 0:
            let titleLabelHeight: CGFloat = 21.5
            let subtitleLabelHeight: CGFloat = 16.0
            let buttonHeight: CGFloat = screenBounds.width * 0.92 * 0.16
            let supplementaryViewSpace: CGFloat = 50.0
            
            return 16.0 + titleLabelHeight
                +  4.0 + subtitleLabelHeight
                +  24.0 + supplementaryViewSpace
                +  24.0 + buttonHeight
                +  16.0
        case 1: return .zero
        default: return .zero
        }
    }
}
