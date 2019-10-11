//
//  RentingGarageDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 24/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

protocol RentingGarageDelegate: class {
    func startedRenting(_ garage: Garage)
    func stoppedRenting()
}
