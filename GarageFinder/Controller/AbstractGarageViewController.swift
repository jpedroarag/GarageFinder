//
//  AbstractGarageViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class AbstractGarageViewController: UIViewController {
    
    weak var changeScrollViewDelegate: ChangeScrollViewDelegate?
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "close")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.bounces = false
        table.showsVerticalScrollIndicator = false
        table.register(DetailsTableViewCell.self, forCellReuseIdentifier: "detailsCell")
        return table
    }()
    
    var garageInfoView: GarageInfoView {
        return GarageInfoView(frame: .zero)
    }
    
    var numberOfSections = 1
    var shouldAppearAnimated = false
    var sectionSeparatorsStartAppearIndex = 0
    weak var selectGarageDelegate: SelectGarageDelegate?
    
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
            .top(view.topAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8 + 8)
            .width(constant: 24)
            .height(constant: 24)
        tableView.anchor
            .top(view.topAnchor, padding: 16 + 8)
            .left(view.leftAnchor, padding: 8)
            .right(view.rightAnchor, padding: 8)
            .bottom(view.bottomAnchor)
    }
    
    @objc func closeButtonTapped() {
        dismissFromParent()
        selectGarageDelegate?.didDismissGarage()
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
extension AbstractGarageViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        changeScrollViewDelegate?.didChange(scrollView: scrollView)
    }
}
