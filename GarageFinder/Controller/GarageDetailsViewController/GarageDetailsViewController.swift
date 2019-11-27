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
    
    var waitingView: ParkingWaitingView = {
        let view = ParkingWaitingView()
        view.loadingIndicator.color = .customGreen
        view.messageLabel.textColor = .darkGray
        return view
    }()
    
    var parking: Parking?
    
    private var mutableGarageInfoView: GarageInfoView!
    override var garageInfoView: GarageInfoView {
        if let view = mutableGarageInfoView {
            return view
        } else {
            let view = GarageInfoView(collapsed: false, buttonTitle: "Estacionar")
            view.loadData(presentedGarage)
            presentedGarage.loadUserImage { image in
                DispatchQueue.main.async {
                    let predicate = NSPredicate(format: "(objectId == %d)", self.presentedGarage.id)
                    if let favorite = CoreDataManager.shared.fetch(Favorite.self, predicate: predicate).first {
                        if favorite.imageBase64 == "" {
                            favorite.imageBase64 = image?.toBase64()
                            CoreDataManager.shared.saveChanges()
                        }
                        self.actionsDelegate?.reloadLikedGarage()
                    }
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
            var imageBase64: String? = ""
            if garageInfoView.component.leftImageView.image != UIImage(named: "profile") {
                imageBase64 = garageInfoView.component.leftImageView.image?.toBase64()
            }
            let favorite = Favorite(name: garage.description ?? "Garagem",
                                    address: garage.address?.description,
                                    category: .other,
                                    latitude: garage.address?.coordinate.latitude ?? 0,
                                    longitude: garage.address?.coordinate.longitude ?? 0,
                                    type: .garage,
                                    objectId: garage.id,
                                    average: garage.average ?? 0,
                                    imageBase64: imageBase64)
            dataManager.insert(object: favorite)
            actionsDelegate?.reloadLikedGarage()
        }
    }
    
}

// MARK: UI Functions (section removing and alert)
extension GarageDetailsViewController {
    
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
    
}

// MARK: Parking stuff
extension GarageDetailsViewController {
    
    @objc func parkButtonTapped(_ sender: GFButton) {
        
        let alert = UIAlertController(title: "Estacionamento", message: "Você deseja confirmar o estacionamento neste local?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            if UserDefaults.userIsLogged && UserDefaults.tokenIsValid {
                self.garageInfoView.button.action = nil
                self.waitForConfirmation()
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
    
    func waitForConfirmation() {
        garageInfoView.button.action = cancelParkingRequest(_:)
        garageInfoView.button.setTitle("Cancelar", for: .normal)
        garageInfoView.button.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        closeButton.isHidden = true
        
        waitingView.startWaiting(withMessage: "Esperando confirmação da garagem...")
        waitingView.alpha = 0
        
        removeAdditionalSections(animated: true) {
            self.garageInfoView.addSupplementaryView(self.waitingView, withHeight: 64) {
                UIView.animate(withDuration: 0.7, animations: {
                    self.waitingView.alpha = 1
                }, completion: { _ in
                    self.tableView.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // For some reason, when table reloads its data,
                        self.waitingView.loadingIndicator.startAnimating()  // it stops the loading indicator...
                    }
                    self.fireRenting()
                })
            }
        }
        
    }
    
    @objc func cancelParkingRequest(_ sender: GFButton) {
        let controller = GarageDetailsViewController()
        let floatingController = self.rentingGarageDelegate as? FloatingViewController
        controller.changeScrollViewDelegate = floatingController
        controller.rentingGarageDelegate = floatingController
        controller.selectGarageDelegate = floatingController
        controller.actionsDelegate = floatingController
        controller.presentedGarage = self.presentedGarage
        controller.garageInfoView.loadImage(self.garageInfoView.component.leftImageView.image)
        controller.garageInfoView.component.isCollapsed = self.garageInfoView.component.isCollapsed
        floatingController?.floatingView.floatingViewPositioningDelegate = controller
        
        floatingController?.addChild(controller)
        if let floatingView = floatingController?.view {
            floatingView.insertSubview(controller.view, at: floatingView.subviews.count - 1)
            controller.view.frame = self.view.frame
        }
        controller.didMove(toParent: floatingController)
        
        sender.backgroundColor = .customGreen
        sender.setTitle("Estacionar", for: .normal)
        self.closeButton.isHidden = false
        self.garageInfoView.removeSupplementaryView {
            UIView.animate(withDuration: 0.7, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.view.removeFromSuperview()
                self.removeFromParent()
            })
        }
    }
    
    func parkingRequest(wasAccepted accepted: Bool) {
        if accepted {
            garageInfoView.button.backgroundColor = .customGreen
            garageInfoView.button.setTitle("Cheguei!", for: .normal)
            garageInfoView.button.action = startRenting(_:)
            waitingView.stopWaiting(withNewMessage: "Confirme quando você chegar na garagem. Não se preocupe, nada será cobrado antes de você chegar lá 😉")
        } else {
            cancelParkingRequest(garageInfoView.button)
        }
    }
    
    func fireRenting() {
        var parking = Parking(garageOwnerId: presentedGarage.userId,
                              driverId: UserDefaults.loggedUserId,
                              garageId: presentedGarage.id)
        URLSessionProvider().request(.post(parking)) { result in
            switch result {
            case .success(let response):
                if let parkingResponse = response.result {
                    parking.id = parkingResponse.id
                    self.parking = parkingResponse
                }
            case .failure(let error):
                print("Error posting parking: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Algo deu errado. Tente novamente.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.cancelParkingRequest(self.garageInfoView.button)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func startRenting(_ sender: GFButton) {
        let rentingCounterView = RentingCounterView(frame: .zero)
        rentingCounterView.alpha = 0
        
        garageInfoView.button.setTitle("Concluir", for: .normal)
        self.garageInfoView.removeSupplementaryView(animated: true) {
            self.garageInfoView.addSupplementaryView(rentingCounterView) {
                UIView.animate(withDuration: 0.7, animations: {
                    rentingCounterView.alpha = 1
                }, completion: { _ in
                    if let parking = self.parking {
                        self.parking?.fire()
                        self.rentingGarageDelegate?.startedRenting(garage: self.presentedGarage,
                                                                   parking: parking,
                                                                   createdNow: true)
                    }
                })
            }
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
