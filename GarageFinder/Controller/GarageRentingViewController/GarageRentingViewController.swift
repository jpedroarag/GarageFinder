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
    
    lazy var rentingObject = Parking()
    lazy var isRunning = true
    var rentedGarage: Garage!
    
    weak var garageRatingDelegate: GarageRatingDelegate?
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: true)
            view.loadData(rentedGarage)
            view.button.setTitle("Concluir", for: .normal)
            view.button.action = concludeAction(_:)
            view.addSupplementaryView(rentingCounterView, animated: false, nil)
            self.mutableGarageInfoView = view
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
    
    func concludeAction(_ button: GFButton) {
        
        let alert = UIAlertController(title: "Concluir", message: "Você deseja concluir o estacionamento?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            UIView.animate(withDuration: 0.175, animations: {
                button.alpha = 0
            }, completion: { _ in
                button.setTitle("Pagar", for: .normal)
                UIView.animate(withDuration: 0.175, animations: {
                    button.alpha = 1
                })
                
                button.action = self.paymentAction(_:)
            })
            self.isRunning = false
            self.rentingObject.conclude()
            self.update()
            self.uploadParking(withMethod: .update(self.rentingObject))
        }))
                
        present(alert, animated: true, completion: nil)
        
    }

    func paymentAction(_ button: GFButton) {
        // TODO: Payment action
        showRatingView(button)
    }
    
    func showRatingView(_ button: GFButton) {
        let ratingView = RatingView()
        ratingView.alpha = 0
        removeLastSection()
        self.garageRatingDelegate?.willStartRating()
        mutableGarageInfoView.addSupplementaryView(ratingView) {
            UIView.animate(withDuration: 0.175, animations: {
                button.alpha = 0
            }, completion: { _ in
                button.setTitle("Avaliar", for: .normal)
                UIView.animate(withDuration: 0.2, animations: {
                    ratingView.alpha = 1
                    button.alpha = 1
                }, completion: { _ in
                    self.garageRatingDelegate?.didStartRating(self.rentedGarage)
                })
            })
        }
        garageInfoView.component.isCollapsed = true
        
    }
    private func removeLastSection() {
        numberOfSections -= 1
        tableView.deleteSections([numberOfSections], with: .fade)
    }
    
    func fireRenting() {
        uploadParking(withMethod: .post(rentingObject))
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
        rentingDetailsController.loadData(rentingObject)
        rentingCounterView.timerLabel.text = rentingObject.permanenceDurationString()
        rentingCounterView.priceLabel.text = rentingObject.priceString()
    }
    
    func uploadParking(withMethod method: NetworkService<Parking>) {
        URLSessionProvider().request(method) { result in
            switch result {
            case .success(let response):
                if let parking = response.result {
                    self.rentingObject.id = parking.id
                }
            case .failure(let error):
                print("Error posting parking: \(error)")
            }
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
