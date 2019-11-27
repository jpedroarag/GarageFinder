//
//  MapSettingsViewController.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 21/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class MapSettingsViewController: UIViewController {

    lazy var optionSelectorViewController = OptionSelectorViewController()
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    let settings = ["Trânsito"]
    
    var optionSelectorHeight: CGFloat {
        return 64.0
    }
    
    var tableViewHeight: CGFloat {
        return 48.0 * CGFloat(settings.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionSelectorViewController.setOptions(options: "Mapa", "Satélite")
        optionSelectorViewController.view.backgroundColor = .clear
        addChild(optionSelectorViewController)
        optionSelectorViewController.didMove(toParent: self)
        
        var indexPath = IndexPath(item: 0, section: 0)
        if let option = UserDefaults.standard.valueForLoggedUser(forKey: "MapOption") as? String {
            for index in 0..<optionSelectorViewController.options.count
                      where optionSelectorViewController.options[index] == option {
                indexPath = [0, index]
            }
        }
        
        optionSelectorViewController.collectionView.selectItem(at: indexPath,
                                                               animated: true,
                                                               scrollPosition: .left)

        optionSelectorViewController.optionSelected = { option in
            UserDefaults.standard.setValueForLoggedUser(option, forKey: "MapOption")
            NotificationCenter.default.post(name: .mapOptionSettingDidChange, object: option)
        }
        
        view.addSubview(optionSelectorViewController.view)
        view.addSubview(tableView)
        setConstraints()
    }
    
    func setConstraints() {
        optionSelectorViewController.view.anchor
            .top(view.topAnchor)
            .left(view.leftAnchor)
            .right(view.rightAnchor)
            .height(constant: optionSelectorHeight)
        tableView.anchor
            .top(optionSelectorViewController.view.bottomAnchor)
            .left(view.leftAnchor)
            .right(view.rightAnchor)
            .height(constant: tableViewHeight)
    }
    
    func remakeConstraints() {
        optionSelectorViewController.view.anchor.deactivateConstraints(withLayoutAttributes: .top, .left, .right, .height)
        tableView.anchor.deactivateConstraints(withLayoutAttributes: .top, .left, .right, .height)
        setConstraints()
    }
    
    @objc func switched(_ sender: UISwitch) {
        UserDefaults.standard.setValueForLoggedUser(sender.isOn, forKey: "TrafficOption")
        NotificationCenter.default.post(name: .trafficSettingDidChange, object: sender.isOn)
    }
    
}

extension MapSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switcher = UISwitch()
        switcher.tintColor = .customGreen
        switcher.addTarget(self, action: #selector(switched(_:)), for: .valueChanged)
        
        let isOn = UserDefaults.standard.valueForLoggedUser(forKey: "TrafficOption") as? Bool
        switcher.isOn = isOn ?? false
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryView = switcher
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
    
}

extension MapSettingsViewController: SettingSectionController {
    var contentHeight: CGFloat {
        return optionSelectorHeight + tableViewHeight
    }
}
