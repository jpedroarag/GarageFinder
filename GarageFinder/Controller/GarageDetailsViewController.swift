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
        table.rowHeight = UITableView.automaticDimension
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "Fotos"
        case 2: return "Comentários"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as? DetailsTableViewCell else {
            return UITableViewCell()
        }
        let sectionHeaderTitle = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: indexPath.row)
        cell.sectionHeaderLabel.text = sectionHeaderTitle
        return cell
    }
}

extension GarageDetailsViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = false
    }
}
