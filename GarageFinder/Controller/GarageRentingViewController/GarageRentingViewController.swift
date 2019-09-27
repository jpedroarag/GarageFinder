
//
//  GarageRentingViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class GarageRentingViewController: AbstractGarageViewController {
    
    lazy var rentingObject = Renting()
    lazy var isRunning = true
    var rentedGarage = Garage()
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: true)
            view.loadData(rentedGarage)
            view.button.setTitle("Concluir", for: .normal)
            view.button.action = { button in
                UIView.animate(withDuration: 0.175, animations: {
                    button.alpha = 0
                }, completion: { _ in
                    button.action = nil
                    button.setTitle("Pagar", for: .normal)
                    UIView.animate(withDuration: 0.175, animations: {
                        button.alpha = 1
                    })
                })
                self.isRunning = false
                self.rentingObject.conclude()
                self.update()
                self.pay()
            }
            view.addSupplementaryView(rentingCounterView, animated: false, nil)
            return view
        }
    }
    
    lazy var rentingCounterView = RentingCounterView()

    lazy var rentingDetailsController: RentingDetailsViewController = {
        let controller = RentingDetailsViewController()
        addChild(controller)
        controller.didMove(toParent: self)
        controller.loadData(self.rentingObject)
        return controller
    }()
    
    var detailsView: UIView {
        return rentingDetailsController.view
    }

    override func viewDidLoad() {
        shouldAppearAnimated = false
        numberOfSections = 1
        sectionSeparatorsStartAppearIndex = 1
        super.viewDidLoad()
        fireRenting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if numberOfSections == 1 {
            numberOfSections += 1
            tableView.insertSections([1], with: .fade)
        }
    }
    
    func fireRenting() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isRunning {
                self.update()
            } else {
                timer.invalidate()
            }
        }
    }
    
    func update() {
        rentingObject.update()
        rentingDetailsController.loadData(self.rentingObject)
        rentingCounterView.timerLabel.text = rentingObject.permanenceDurationString
        rentingCounterView.priceLabel.text = rentingObject.priceString
    }
    
    func pay() {
        // TODO: Payment action
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
        case 1: return detailsView
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
        case 1:
            let headerLabelHeight: CGFloat = 17.0
            let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            let height: CGFloat = "Value".heightOfString(usingFont: font)
            let insets: CGFloat = 16
            return 16.0
                +  headerLabelHeight
                +  4.0
                +  (height + insets) * 4.0
                +  16.0
        default: return .zero
        }
    }
}