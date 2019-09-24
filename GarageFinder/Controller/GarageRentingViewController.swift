
//
//  GarageRentingViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageRentingViewController: UIViewController {
    
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
    
    var garageInfoView: GarageInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(tableView)
        view.addSubview(closeButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        setConstraints()
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
extension GarageRentingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Detalhes"
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
        separator.backgroundColor = section > 0 ? UIColor(rgb: 0xBEBEBE, alpha: 100) : .clear
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
            return garageInfoView
        case 1: return nil
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        switch indexPath.section {
        case 0:
            let titleLabelHeight: CGFloat = 21.5
            let subtitleLabelHeight: CGFloat = 16.0
            let buttonHeight: CGFloat = screenBounds.width * 0.92 * 0.16
            let supplementaryViewSpace: CGFloat = 50.0
            
            return 16.0 + titleLabelHeight
                +  4.0 + subtitleLabelHeight
                +  24.0 + supplementaryViewSpace
                +  24.0 + buttonHeight
                +  16.0
        case 1: return .zero
        default: return .zero
        }
    }
}

// MARK: UIScrollViewDelegate implement
extension GarageRentingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
