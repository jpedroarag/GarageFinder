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
            self.isParking = false
            self.parkingObject.conclude()
            self.update()
            print("PATCH: ")
            self.uploadParking(withMethod: .update(self.parkingObject))
        }))
                
        present(alert, animated: true, completion: nil)
        
    }

    func paymentAction(_ button: GFButton) {
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
    
    func fireRenting() {
        update()
        if createdNow {
            uploadParking(withMethod: .post(parkingObject))
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isParking {
                self.update()
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
    
    func uploadParking(withMethod method: NetworkService<Parking>) {
        URLSessionProvider().request(method) { result in
            switch result {
            case .success(let response):
                if let parking = response.result {
                    self.parkingObject.id = parking.id
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
        switch indexPath.section {
        case 0:
            if UIScreen.main.bounds.width < 500 {
                return 192 + 64
            } else {
                return 192 + 164
            }
        case 1:
            let font: UIFont = .systemFont(ofSize: 16, weight: .regular)
            let height: CGFloat = "Value".heightOfString(usingFont: font)
            let insets: CGFloat = 16
            return (height + insets) * 4.0 + 48.0
        default: return .zero
        }
    }
}

extension GarageRentingViewController: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        
    }
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
    }
}
