//
//  GarageDetailViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 05/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework

class GarageDetailsViewController: AbstractGarageViewController {
    
    lazy var floatingViewShouldStopListeningToPan = false
    weak var rentingGarageDelegate: RentingGarageDelegate?
    weak var actionsDelegate: GarageActionsDelegate?
    var presentedGarage: Garage!
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(frame: .zero)
            view.loadData(presentedGarage)
            view.button.action = parkButtonTapped(_:)
            mutableGarageInfoView = view
            return view
        }
    }
    
    var garageActionsView: GarageActionsView {
        let garageActionsView = GarageActionsView(frame: .zero)
        garageActionsView.likeButton.action = { _ in self.favoriteGarage(self.presentedGarage) }
        garageActionsView.rateButton.action = { _ in print("rate") }
        garageActionsView.shareButton.action = { _ in print("share") }
        garageActionsView.reportButton.action = { _ in print("report") }
        return garageActionsView
    }
    
    var garageGalleryView: GarageGalleryView {
        return GarageGalleryView(images: [])
    }
    
    lazy var ratingListController: GarageRatingListViewController = {
        let controller = GarageRatingListViewController()
        self.addChild(controller)
        controller.didMove(toParent: self)
        //controller.loadRatings(self.presentedGarage.comments ?? [])
        return controller
    }()
    
    var ratingsView: UIView {
        return ratingListController.view
    }
    
    override func viewDidLoad() {
        numberOfSections = 4
        shouldAppearAnimated = true
        sectionSeparatorsStartAppearIndex = 2
        super.viewDidLoad()
    }
    
    func favoriteGarage(_ garage: Garage) {
        let dataManager = CoreDataManager.shared
        let predicate = NSPredicate(format: "(objectId = %d)", garage.id)
        if let favorite = dataManager.fetch(Favorite.self, predicate: predicate).first {
            dataManager.delete(object: favorite)
            actionsDelegate?.unlikedGarage()
            return
        } else {
            let favorite = Favorite(name: garage.description ?? "Garagem",
                                    category: .other,
                                    latitude: garage.address?.coordinate.latitude ?? 0,
                                    longitude: garage.address?.coordinate.longitude ?? 0,
                                    type: .garage,
                                    objectId: garage.id)
            dataManager.insert(object: favorite)
            actionsDelegate?.likedGarage()
        }
    }
    
    func parkButtonTapped(_ sender: GFButton) {
        
        let alert = UIAlertController(title: "Estacionamento", message: "Você deseja confirmar o estacionamento neste local?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            sender.action = nil
            self.removeAdditionalSections(animated: true) {
                sender.setTitle("Concluir", for: .normal)
                self.startRenting()
            }
        }))
                
        present(alert, animated: true, completion: nil)
    }
    
    private func removeLastSection() {
        numberOfSections -= 1
        tableView.deleteSections([numberOfSections], with: .fade)
    }
    
    private func removeAllAdditionalSections() {
        numberOfSections = 1
        tableView.deleteSections([1, 2, 3], with: .none)
    }
    
    private func removeAdditionalSections(animated: Bool = true, _ completion: (() -> Void)? = nil) {
        if animated {
            let upperBound = numberOfSections
            (1...upperBound).forEach { index in
                let sectionsRemovingDeadline = 0.35 * Double(index)
                let completionDeadline = 0.7
                let deadline = DispatchTime.now() + (index != 4 ? sectionsRemovingDeadline : completionDeadline)
                DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                    index != 3 ? self.removeLastSection() : completion?()
                })
            }
        } else {
            self.removeAllAdditionalSections()
        }
    }
    
    func startRenting() {
        let rentingCounterView = RentingCounterView(frame: .zero)
        rentingCounterView.alpha = 0
        self.garageInfoView.addSupplementaryView(rentingCounterView) {
            UIView.animate(withDuration: 0.7, animations: {
                rentingCounterView.alpha = 1
            }, completion: { _ in
                self.rentingGarageDelegate?.startedRenting(garage: self.presentedGarage, parking: Parking(), createdNow: true)
            })
        }
        self.garageInfoView.component.isCollapsed = true
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate implement
extension GarageDetailsViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2: return "Fotos"
        case 3: return "Comentários"
        default: return nil
        }
    }
    
    override func sectionContent(forIndexPath indexPath: IndexPath) -> UIView? {
        switch indexPath.section {
        case 0: return garageInfoView
        case 1: return garageActionsView
        case 2: return garageGalleryView
        case 3: return ratingsView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let headerLabelHeight: CGFloat = 17.0
        switch indexPath.section {
        case 0:
            let titleLabelHeight: CGFloat = 21.5
            let subtitleLabelHeight: CGFloat = 16.0
            let buttonHeight: CGFloat = screenBounds.width * 0.92 * 0.16
            var supplementaryViewSpace: CGFloat = 0
            
            if numberOfSections == 1 {
                supplementaryViewSpace = 24.0 + 50.0
            }

            return 16.0 + titleLabelHeight
                 +  4.0 + subtitleLabelHeight
                 +  supplementaryViewSpace
                 +  24.0 + buttonHeight
                 +  16.0
        case 1:
            let ratio: CGFloat = 0.128
            let screenWidth: CGFloat = screenBounds.width
            return 8.0 + ratio * screenWidth + 8.0
        case 2:
            return 16.0 + headerLabelHeight
                 +  4.0
                 +  5.0
                 + UIScreen.main.bounds.height * 0.2
                 +  5.0
                 +  16.0
        default:
            let ratingsCount = ratingListController.ratings.isEmpty ? 1 :  ratingListController.ratings.count
            let rowHeight: CGFloat = 64 + 4
            let bottomInset: CGFloat = UIScreen.main.bounds.height * 187.5/667
            return (rowHeight * CGFloat(ratingsCount)) + bottomInset
        }
    }
}

extension GarageDetailsViewController: FloatingViewPositioningDelegate {
    func didEntered(in position: FloatingViewPosition) {
        garageInfoView.component.isCollapsed = position == .full ? true : false
    }
}
