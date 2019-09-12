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
//        table.estimatedRowHeight = 128
        table.backgroundColor = .clear
        table.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
        .left(view.leftAnchor)
        .right(view.rightAnchor)
        .bottom(view.bottomAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func closeButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }, completion: { _ in
            self.removeFromParent()
            self.view.removeFromSuperview()
        })
    }
}

extension GarageDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Fotos"
        case 2: return "Comentários"
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
        separator.backgroundColor = section != 0 ? UIColor.black.withAlphaComponent(0.15) : .clear
        view.addSubview(separator)
        
        separator.anchor
        .top(view.topAnchor)
        .bottom(view.bottomAnchor)
        .width(view.widthAnchor, multiplier: 0.8)
        .centerX(view.centerXAnchor)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailsTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionHeaderTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: indexPath.section)
        cell.sectionHeaderLabel.text = sectionHeaderTitle
        
        if let contentView = sectionContent(forIndexPath: indexPath) {
            cell.addContentView(contentView)
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
            var pictures = [UIImage]()
            (0...5).forEach { _ in
                guard let image = UIImage(named: "mock") else { return }
                pictures.append(image)
            }
            return GarageGalleryView(images: pictures)
        case 2:
            let table = UITableView()
            table.backgroundColor = .red
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

            return 16.0 + headerLabelHeight
                 + 16.0 + titleLabelHeight
                 +  4.0 + subtitleLabelHeight
                 +  8.0 + buttonHeight
                 +  16.0
        case 1:
            return 16.0 + headerLabelHeight
                 + 16.0
                 +  5.0
                 + UIScreen.main.bounds.height * 0.2
                 +  5.0
                 +  16.0
        default: return UITableView.automaticDimension
        }
    }
}

extension GarageDetailsViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === tableView && scrollView.isScrollEnabled { scrollView.isScrollEnabled = false }
    }
}
