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
            let view = GarageInfoView(collapsed: false, buttonTitle: "Estacionar")
            view.loadData(presentedGarage)
            presentedGarage.loadUserImage { image in
                DispatchQueue.main.async {
                    view.loadImage(image)
                }
            }
            view.button.action = parkButtonTapped(_:)
            mutableGarageInfoView = view
            return view
        }
    }
    
    var garageActionsView: GarageActionsView {
        let predicate = NSPredicate(format: "(objectId == %d)", presentedGarage.id)
        let isFavorite = (CoreDataManager.shared.fetch(Favorite.self, predicate: predicate).first != nil)
        let garageActionsView = GarageActionsView(likeButtonFilled: isFavorite)
        garageActionsView.likeButton.action = { _ in
            // TODO: Metrify here
            self.favoriteGarage(self.presentedGarage)
        }
        garageActionsView.rateButton.action = { _ in
            self.soonFeatureAlertController()
        }
        garageActionsView.shareButton.action = { _ in
            self.soonFeatureAlertController()
        }
        garageActionsView.reportButton.action = { _ in
            self.soonFeatureAlertController()
        }
        return garageActionsView
    }
    
    var garageGalleryView: GarageGalleryView {
        return GarageGalleryView(images: presentedGarage.loadPhotos())
    }
    
    lazy var ratingListController: GarageRatingListViewController = {
        let controller = GarageRatingListViewController()
        self.addChild(controller)
        controller.didMove(toParent: self)
//        var comments = [Comment]()
//        (0...5).forEach { index in
//            comments.append(Comment(id: index,
//                                    fromUserId: UserDefaults.loggedUserId,
//                                    toUserId: presentedGarage.userId,
//                                    garage: presentedGarage,
//                                    title: "Good host",
//                                    message: "Awesome host",
//                                    rating: 4.5))
//        }
        controller.loadRatings(presentedGarage.comments)
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
            actionsDelegate?.reloadLikedGarage()
            return
        } else {
            let favorite = Favorite(name: garage.description ?? "Garagem",
                                    address: garage.address?.description,
                                    category: .other,
                                    latitude: garage.address?.coordinate.latitude ?? 0,
                                    longitude: garage.address?.coordinate.longitude ?? 0,
                                    type: .garage,
                                    objectId: garage.id,
                                    average: garage.average ?? 0)
            dataManager.insert(object: favorite)
            actionsDelegate?.reloadLikedGarage()
        }
    }
    
    @objc func parkButtonTapped(_ sender: GFButton) {
        
        let alert = UIAlertController(title: "Estacionamento", message: "Você deseja confirmar o estacionamento neste local?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
            // TODO: Metrify here
        }))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            // TODO: Metrify here
            if UserDefaults.userIsLogged && UserDefaults.tokenIsValid {
                let waitAlert = UIAlertController(title: "Garagem esperando", message: "Confirme quando você chegar na garagem", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { action in
                    sender.action = nil
                    self.removeAdditionalSections(animated: true) {
                        sender.setTitle("Concluir", for: .normal)
                        self.startRenting()
                    }
                }
                waitAlert.addAction(action)
                self.present(waitAlert, animated: true, completion: nil)
            } else {
                let loginAlert = UIAlertController(title: "Error", message: "Você deve estar logado para estacionar", preferredStyle: .alert)
                loginAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                loginAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { _ in
                    NotificationCenter.default.post(name: .adjustsMenu, object: nil)
                }))
                self.present(loginAlert, animated: true, completion: nil)
            }
        }))
                
        present(alert, animated: true, completion: nil)
    }
    
    func soonFeatureAlertController() {
        let alert = UIAlertController(title: "Em breve", message: "Não disponível ainda", preferredStyle: .alert)
        present(alert, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        }
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
                let parking = Parking(garageOwnerId: self.presentedGarage.userId, driverId: UserDefaults.loggedUserId, garageId: self.presentedGarage.id)
                self.rentingGarageDelegate?.startedRenting(garage: self.presentedGarage, parking: parking, createdNow: true)
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
        case 2:
            if garageGalleryView.photos.isEmpty {
                return PaddedLabel(text: "Sem fotos disponíveis para esta garagem")
            }
            return garageGalleryView
        case 3: return ratingsView
        default: return nil
        }
    }
}

extension GarageDetailsViewController: FloatingViewPositioningDelegate {
    func didEntered(in position: FloatingViewPosition) {
        garageInfoView.component.isCollapsed = position == .full ? true : false
    }
}
