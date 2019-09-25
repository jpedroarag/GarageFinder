//
//  AbstractGarageViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import GarageFinderFramework // TODO: get rid of this (using for inserting mocked data)

class AbstractGarageViewController: UIViewController {
    
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
        table.isScrollEnabled = false
        table.showsVerticalScrollIndicator = false
        table.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        return table
    }()
    
    var temporaryGarageView: GarageInfoView! = { // TODO: Get rid of this ASAP
        let garageInfoView = GarageInfoView(frame: .zero)
        garageInfoView.component.leftImageView.image = UIImage(named: "mockGarage")
        garageInfoView.component.titleLabel.text = "Garagem de Marcus"
        garageInfoView.component.subtitleLabel.text = "St. John Rush, 79"
        garageInfoView.component.ratingLabel.text = "4.3"
        return garageInfoView
    }()
    
    var garageInfoView: GarageInfoView! {
//        let garageInfoView = GarageInfoView(frame: .zero)
//        garageInfoView.loadData(presentedGarage)
//        return garageInfoView
        return temporaryGarageView
    }
    
    var numberOfSections = 1
    var shouldAppearAnimated = false
    var sectionSeparatorsStartAppearIndex = 0
    
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
        appear()
    }
    
    func appear() {
        if shouldAppearAnimated {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0,
                                             width: self.view.frame.width,
                                             height: self.view.frame.height)
                })
            }
        } else {
            self.view.frame = CGRect(x: 0, y: 0,
                                     width: self.view.frame.width,
                                     height: self.view.frame.height)
        }
    }
    
    private func setConstraints() {
        closeButton.anchor
            .top(view.topAnchor, padding: 4)
            .right(view.rightAnchor, padding: 8 + 8)
            .width(constant: 16)
            .height(constant: 16)
        tableView.anchor
            .top(view.topAnchor, padding: 16 + 8)
            .left(view.leftAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8)
            .bottom(view.bottomAnchor)
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

// MARK: UITableViewDataSource, UITableViewDelegate implement
extension AbstractGarageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        let separator = UIView()
        separator.backgroundColor = section >= sectionSeparatorsStartAppearIndex ? UIColor(rgb: 0xBEBEBE, alpha: 100) : .clear
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
    
    @objc func sectionContent(forIndexPath indexPath: IndexPath) -> UIView? {
        switch indexPath.section {
        case 0: return garageInfoView
        default: return nil
        }
    }
}

// MARK: UIScrollViewDelegate implement
extension AbstractGarageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
