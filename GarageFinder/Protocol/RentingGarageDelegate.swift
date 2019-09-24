//
//  RentingGarageDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol RentingGarageDelegate: class {
    func startedRenting(_ garageInfoView: GarageInfoView)
//    func startedRenting(garage: Garage) // This one is the correct one.
    func stoppedRenting()
}
