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
    
    var floatingViewShouldStopListeningToPanGesture = false
    var ratingsDataSourceDelegate: GarageRatingsDataSourceDelegate!
    weak var rentingGarageDelegate: RentingGarageDelegate?
    
    var garageActionsView: GarageActionsView! {
        let garageActionsView = GarageActionsView(frame: .zero)
        garageActionsView.likeButton.action = { _ in print("like") }
        garageActionsView.rateButton.action = { _ in print("rate") }
        garageActionsView.shareButton.action = { _ in print("share") }
        garageActionsView.reportButton.action = { _ in print("report") }
        return garageActionsView
    }
    
    var garageGalleryView: GarageGalleryView! {
        var pictures = [UIImage]()
        (0...5).forEach { _ in
            guard let image = UIImage(named: "mockGarage") else { return }
            pictures.append(image)
        }
        return GarageGalleryView(images: pictures)
    }
    
    var ratingsTable: UITableView! {
        var ratings: [Comment] = []
        (0...7).forEach { _ in
            let comment = Comment(title: "Good host", message: "Very friendly and a very good garage", rating: 4.3)
            ratings.append(comment)
        }
        ratingsDataSourceDelegate = GarageRatingsDataSourceDelegate(ratings: ratings)
        let ratingsTable = UITableView()
        ratingsTable.backgroundColor = .clear
        ratingsTable.separatorStyle = .none
        ratingsTable.isScrollEnabled = false
        ratingsTable.register(RatingTableViewCell.self, forCellReuseIdentifier: "ratingCell")
        ratingsTable.dataSource = ratingsDataSourceDelegate
        ratingsTable.delegate = ratingsDataSourceDelegate
        return ratingsTable
    }
    
    override func viewDidLoad() {
        numberOfSections = 4
        shouldAppearAnimated = true
        indexSectionSeparatorsShouldStartAppearing = 2
        super.viewDidLoad()
    }
    
    @objc override func closeButtonTapped() {
        floatingViewShouldStopListeningToPanGesture = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            let floatingController = self.parent as? FloatingViewController
            floatingController?.floatingViewPositioningDelegate = nil
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
    
    private func removeLastSection() {
        numberOfSections -= 1
        tableView.deleteSections([numberOfSections], with: .fade)
    }
    
    private func removeAllAdditionalSections() {
        numberOfSections = 1
        tableView.deleteSections([1, 2, 3], with: .none)
    }
    
    private func removeAdditionalSections(animated: Bool = true) {
        if animated {
            (1...3).forEach { index in
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.7/4 * Double(index)), execute: {
                    self.removeLastSection()
                })
            }
        } else {
            self.removeAllAdditionalSections()
        }
    }
    
    func startRenting() {
        let rentingCounterView = RentingCounterView(frame: .zero)
        rentingCounterView.alpha = 0
        self.garageInfoView.button.setTitle("Concluir", for: .normal)
        self.garageInfoView.addSupplementaryView(rentingCounterView) {
            UIView.animate(withDuration: 0.7, animations: {
                rentingCounterView.alpha = 1
            }, completion: { _ in
                self.rentingGarageDelegate?.startedRenting(self.garageInfoView)
                self.dismiss()
            })
        }
        self.garageInfoView.component.isCollapsed = true
    }
    
    func dismiss() {
        self.removeFromParent()
        self.view.removeFromSuperview()
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
        case 0:
            let garageInfoView = super.sectionContent(forIndexPath: indexPath) as? GarageInfoView
            garageInfoView?.button.action = { _ in
                self.garageInfoView.button.action = nil
                self.removeAdditionalSections(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.7/4 * 4), execute: {
                    self.startRenting()
                })
            }
            return garageInfoView
        case 1: return garageActionsView
        case 2: return garageGalleryView
        case 3: return ratingsTable
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
            guard let ratingsCount = ratingsDataSourceDelegate?.ratings.count else { return .zero }
            let rowHeight: CGFloat = 64 + 4
            let bottomInset: CGFloat = UIScreen.main.bounds.height * 187.5/667
            return (rowHeight * CGFloat(ratingsCount)) + bottomInset
        }
    }
}

// MARK: UIScrollViewDelegate implement
extension GarageDetailsViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === tableView {
            if scrollView.contentOffset.y <= 0 {
                floatingViewShouldStopListeningToPanGesture = false
                scrollView.isScrollEnabled = false
            }
        }
    }
}

// MARK: FloatingViewPositioningDelegate implement
extension GarageDetailsViewController: FloatingViewPositioningDelegate {
    func enteredFullView() {
        if let infoView = garageInfoView { infoView.component.isCollapsed = true }
        floatingViewShouldStopListeningToPanGesture = true
        tableView.isScrollEnabled = true
    }
    
    func enteredMiddleView() {
        if let infoView = garageInfoView { infoView.component.isCollapsed = false }
        floatingViewShouldStopListeningToPanGesture = false
        tableView.scrollRectToVisible(.zero, animated: true)
        tableView.isScrollEnabled = false
    }
    
    func enteredPartialView() {
        if let infoView = garageInfoView { infoView.component.isCollapsed = false }
        floatingViewShouldStopListeningToPanGesture = false
        tableView.scrollRectToVisible(.zero, animated: true)
        tableView.isScrollEnabled = false
    }
    
    func shouldStopListeningToPanGesture() -> Bool {
        return floatingViewShouldStopListeningToPanGesture
    }
}
