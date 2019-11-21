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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionSelectorViewController.setOptions(options: "Mapa", "Satélite")
        optionSelectorViewController.view.backgroundColor = .clear
        addChild(optionSelectorViewController)
        optionSelectorViewController.didMove(toParent: self)
        
        for index in 0..<optionSelectorViewController.options.count {
            if optionSelectorViewController.options[index] == UserDefaults.standard.string(forKey: "MapOption") {
                optionSelectorViewController.collectionView.selectItem(at: [0, index], animated: true, scrollPosition: .left)
            }
        }
        
        optionSelectorViewController.optionSelected = { option in
            UserDefaults.standard.set(option, forKey: "MapOption")
            NotificationCenter.default.post(name: .mapOptionSettingDidChange, object: nil)
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
            .height(constant: 64)
        tableView.anchor
            .top(optionSelectorViewController.view.bottomAnchor)
            .left(view.leftAnchor)
            .right(view.rightAnchor)
            .height(constant: 48 * CGFloat(settings.count))
    }
    
    func remakeConstraints() {
        optionSelectorViewController.view.anchor.deactivateConstraints(withLayoutAttributes: .top, .left, .right, .height)
        tableView.anchor.deactivateConstraints(withLayoutAttributes: .top, .left, .right, .height)
    }
    
    @objc func switched(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "TrafficOption")
        NotificationCenter.default.post(name: .trafficSettingDidChange, object: nil)
    }
    
}

extension MapSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switcher = UISwitch()
        switcher.tintColor = .customGreen
        switcher.isOn = UserDefaults.standard.bool(forKey: "TrafficOption")
        switcher.addTarget(self, action: #selector(switched(_:)), for: .valueChanged)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryView = switcher
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
    
}
