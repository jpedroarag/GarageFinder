//
//  GarageHistoryViewController.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 28/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit

class GarageHistoryViewController: UIViewController {
    let garageHistoryView = GarageHistoryView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Histórico de Garagens"
        navigationItem.largeTitleDisplayMode = .never
        setNavigationCloseButton()
    }
    
    override func loadView() {
        view = garageHistoryView
//        garageHistoryView.setData(garages: [Favorite(name: "Garagem de Marcus", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage),
//        Favorite(name: "Garagem de Vitor", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage),
//        Favorite(name: "Garagem de Pedro", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage),
//        Favorite(name: "Garagem de Joaquim", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage),
//        Favorite(name: "Garagem de Dano;p", category: .other, latitude: -3.754398, longitude: -38.522078, type: .garage)])
    }
}
