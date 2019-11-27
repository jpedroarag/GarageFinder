//
//  UpdateParkingStatusDelegate.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 27/11/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol UpdateParkingStatusDelegate: class {
    func didUpdateParkingStatus(status: Bool, parkingId: Int)
}
