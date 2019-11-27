//
//  GarageRentingViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import PassKit
import GarageFinderFramework

class GarageRentingViewController: AbstractGarageViewController {
    
    lazy var isParking = true
    lazy var createdNow = true
    
    var parkingObject: Parking! {
        didSet {
            parkingObject.pricePerHour = Float(rentedGarage.price)
        }
    }
    
    var rentedGarage: Garage!
    
    weak var garageRatingDelegate: GarageRatingDelegate?
    weak var garageRentingDelegate: RentingGarageDelegate?
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: true, buttonTitle: "Concluir")
            view.loadData(rentedGarage)
            view.button.action = conclude(_:)
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
        controller.loadData(self.parkingObject)
        return controller
    }()
    
    var detailsView: UIView {
        return rentingDetailsController.view
    }

    override func viewDidLoad() {
        shouldAppearAnimated = false
        numberOfSections = 1
        sectionSeparatorsStartAppearIndex = 1
        closeButton.isHidden = true
        super.viewDidLoad()
        fire()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if numberOfSections == 1 {
            numberOfSections += 1
            tableView.insertSections([1], with: .fade)
        }
    }
    
    func conclude(_ button: GFButton) {
        let alert = UIAlertController(title: "Concluir", message: "Você deseja concluir o estacionamento?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            UIView.animate(withDuration: 0.175, animations: {
                button.alpha = 0
            }, completion: { _ in
                self.mutableGarageInfoView.addPaymentMethodView(PayMethodView())
                self.tableView.reloadSections([0, 1], with: .fade)
                button.setTitle("Pagar", for: .normal)
                UIView.animate(withDuration: 0.175, animations: {
                    button.alpha = 1
                })
                button.action = self.pay(_:)
            })
            self.exit()
        }))
                
        present(alert, animated: true, completion: nil)
        
    }

    func pay(_ button: GFButton) {
        UIView.animate(withDuration: 0.3) {
            self.garageInfoView.paymentMethodView?.alpha = 0
        }
        
        // TODO: Payment action
        self.garageRentingDelegate?.stoppedRenting()
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
    
    func fire() {
        update()
        if createdNow {
            updateRemoteParking()
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isParking {
                DispatchQueue.main.async { self.update() }
            } else {
                timer.invalidate()
            }
        }
    }
    
    func update() {
        parkingObject.update()
        rentingDetailsController.loadData(parkingObject)
        rentingCounterView.timerLabel.text = parkingObject.permanenceDurationString()
        rentingCounterView.priceLabel.text = parkingObject.priceString()
    }
    
    func exit() {
        isParking = false
        parkingObject.conclude()
        update()
        updateRemoteParking()
    }
    
    func updateRemoteParking() {
        var parking = Parking(id: parkingObject.id)
        parking.end = parkingObject.end
        URLSessionProvider().request(.update(parking)) { result in
            switch result {
            case .success(let response):
                print("PATCH: Success posting parking: \(response.result?.id ?? -1)")
            case .failure(let error):
                print("PATCH: Error posting parking: \(error)")
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
}
