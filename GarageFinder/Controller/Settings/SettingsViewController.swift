//
//  SettingsViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 21/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "settingCell")
        return view
    }()
    
    lazy var settingsSectionViewControllers = [UIViewController]()
    lazy var mapSettingsController = MapSettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.anchor.attatch(to: view)
        addSectionController(mapSettingsController)
    }
    
    func addSectionController(_ controller: SettingSectionController) {
        settingsSectionViewControllers.append(controller)
        addChild(controller)
        controller.didMove(toParent: self)
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSectionViewControllers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Map Settings"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
            cell.selectionStyle = .none
            cell.addSubview(mapSettingsController.view)
            mapSettingsController.view.anchor.deactivateAll()
            mapSettingsController.view.anchor.attatch(to: cell)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return mapSettingsController.contentHeight
        }
        return 0
    }
    
}
