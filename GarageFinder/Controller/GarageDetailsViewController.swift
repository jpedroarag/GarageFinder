//
//  GarageDetailViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 05/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework // TODO: get rid of this (using for inserting mocked data)

class GarageDetailsViewController: UIViewController {

    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 192
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        return table
    }()
    
    var floatingViewShouldStopListeningToPanGesture = false
    var ratingsDataSourceDelegate: GarageRatingsDataSourceDelegate!
    var garageInfoView: GarageInfoView!
    weak var changeScrollViewDelegate: ChangeScrollViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        setConstraints()
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: 0, y: 0,
                                         width: self.view.frame.width,
                                         height: self.view.frame.height)
            })
        }
    }
    
    private func setConstraints() {
        closeButton.anchor
            .top(view.topAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8 + 8)
            .width(constant: 16)
            .height(constant: 16)
        tableView.anchor
            .top(view.topAnchor, padding: 16 + 5 + 8)
            .left(view.leftAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8)
            .bottom(view.bottomAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func closeButtonTapped() {
        dismissFromParent()
    }
    
    func dismissFromParent() {
        self.removeFromParent()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.view.removeFromSuperview()
        })
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate implement
extension GarageDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 2: return "Fotos"
        case 3: return "Comentários"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        let separator = UIView()
        separator.backgroundColor = section > 1 ? UIColor(rgb: 0xBEBEBE, alpha: 100) : .clear
        view.addSubview(separator)
        
        separator.anchor
        .top(view.topAnchor)
        .bottom(view.bottomAnchor)
        .width(view.widthAnchor, multiplier: 0.712)
        .centerX(view.centerXAnchor)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionHeaderTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: indexPath.section)
        cell.sectionHeaderLabel.text = sectionHeaderTitle
        
        if cell.content == nil {
            if let contentView = sectionContent(forIndexPath: indexPath) {
                cell.addContentView(contentView)
            }
        }
        
        return cell
    }
    
    // TODO: Get real data, instead of mocked data
    func sectionContent(forIndexPath indexPath: IndexPath) -> UIView? {
        switch indexPath.section {
        case 0:
            garageInfoView = GarageInfoView(frame: .zero)
            garageInfoView.component.leftImageView.image = UIImage(named: "mockGarage")
            garageInfoView.component.titleLabel.text = "Garagem de Marcus"
            garageInfoView.component.subtitleLabel.text = "St. John Rush, 79"
            garageInfoView.component.ratingLabel.text = "4.3"
            garageInfoView.parkButton.action = { _ in print("park") }
            return garageInfoView
        case 1:
            let garageActionsView = GarageActionsView(frame: .zero)
            garageActionsView.likeButton.action = { _ in print("like") }
            garageActionsView.rateButton.action = { _ in print("rate") }
            garageActionsView.shareButton.action = { _ in print("share") }
            garageActionsView.reportButton.action = { _ in print("report") }
            return garageActionsView
        case 2:
            var pictures = [UIImage]()
            (0...5).forEach { _ in
                guard let image = UIImage(named: "mockGarage") else { return }
                pictures.append(image)
            }
            return GarageGalleryView(images: pictures)
        case 3:
            var ratings: [Comment] = []
            (0...7).forEach { _ in
                let comment = Comment(title: "Good host", message: "Very friendly and a very good garage", rating: 4.3)
                ratings.append(comment)
            }
            ratingsDataSourceDelegate = GarageRatingsDataSourceDelegate(ratings: ratings)
            let table = UITableView()
            table.backgroundColor = .clear
            table.separatorStyle = .none
            table.register(RatingTableViewCell.self, forCellReuseIdentifier: "ratingCell")
            table.dataSource = ratingsDataSourceDelegate
            table.delegate = ratingsDataSourceDelegate
            return table
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

            return 16.0 + titleLabelHeight
                 +  4.0 + subtitleLabelHeight
                 +  24.0 + buttonHeight
                 +  16.0
        case 1:
            let ratio: CGFloat = 0.128
            let screenWidth: CGFloat = screenBounds.width
            return 8.0
                 + ratio * screenWidth
                 + 8.0
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
            let height: CGFloat = rowHeight * CGFloat(ratingsCount)
            let bottomInset: CGFloat = UIScreen.main.bounds.height * 187.5/667
            return height + bottomInset
        }
    }
}

// MARK: UIScrollViewDelegate implement
extension GarageDetailsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeScrollViewDelegate?.didChange(scrollView: scrollView)
    }
}

extension GarageDetailsViewController: FloatingViewPositioningDelegate {
    func didEntered(in position: FloatingViewPosition) {
        garageInfoView?.component.isCollapsed = position == .full ? true : false
    }
}
