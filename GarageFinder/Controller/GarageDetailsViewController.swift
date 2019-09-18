//
//  GarageDetailViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 05/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageDetailsViewController: UIViewController {

    let closeButton: UIButton = {
       let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 192
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        return table
    }()
    
    var floatingViewShouldStopListeningToPanGesture = false
    var ratingsDataSourceDelegate: GarageRatingsDataSourceDelegate!
    
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
            .top(view.topAnchor, padding: 16)
            .right(view.rightAnchor, padding: 16)
            .width(constant: 30)
            .height(constant: 30)
        tableView.anchor
            .top(view.topAnchor, padding: 16)
            .left(view.leftAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8)
            .bottom(view.bottomAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func closeButtonTapped() {
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
            let garageInfoView = GarageInfoView(frame: .zero)
            garageInfoView.titleLabel.text = "Garagem de Marcus"
            garageInfoView.subtitleLabel.text = "St. John Rush, 79"
            garageInfoView.ratingLabel.text = "4.3"
            return garageInfoView
        case 1:
            return GarageActionsView(frame: .zero)
        case 2:
            var pictures = [UIImage]()
            (0...5).forEach { _ in
                guard let image = UIImage(named: "mock") else { return }
                pictures.append(image)
            }
            return GarageGalleryView(images: pictures)
        case 3:
            var ratings: [Rating] = []
            (0...5).forEach { _ in
                ratings.append(Rating(title: "Good host", subtitle: "Very friendly and a very good garage", rating: "4.3"))
            }
            ratingsDataSourceDelegate = GarageRatingsDataSourceDelegate(ratings: ratings)
            let table = UITableView()
            table.backgroundColor = .clear
            table.separatorStyle = .none
            table.isScrollEnabled = false
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
                 +  8.0 + buttonHeight
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
            let ratingsCount: CGFloat = 6
            let rowHeight: CGFloat = 64 + 4
            let height: CGFloat = rowHeight * ratingsCount
            let bottomInset: CGFloat = UIScreen.main.bounds.height * 187.5/667
            return height + bottomInset
        }
    }
}

// MARK: UIScrollViewDelegate implement
extension GarageDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        floatingViewShouldStopListeningToPanGesture = true
        tableView.isScrollEnabled = true
    }
    
    func enteredMiddleView() {
        floatingViewShouldStopListeningToPanGesture = false
        tableView.scrollRectToVisible(.zero, animated: true)
        tableView.isScrollEnabled = false
    }
    
    func enteredPartialView() {
        floatingViewShouldStopListeningToPanGesture = false
        tableView.scrollRectToVisible(.zero, animated: true)
        tableView.isScrollEnabled = false
    }
    
    func shouldStopListeningToPanGesture() -> Bool {
        return floatingViewShouldStopListeningToPanGesture
    }
}
