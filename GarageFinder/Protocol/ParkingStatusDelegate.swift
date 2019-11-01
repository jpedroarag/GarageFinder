//
//  ParkingStatusDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 01/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol ParkingStatusDelegate: class {
    var isUserParking: Bool { get }
    func dismissRenting()
    func loadData(fromLogin: Bool)
}
