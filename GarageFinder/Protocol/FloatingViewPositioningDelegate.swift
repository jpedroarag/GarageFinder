//
//  FloatingControllerDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 15/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

enum FloatingViewPosition: Int {
    case partial = 0
    case middle = 1
    case full = 2
}
protocol FloatingViewPositioningDelegate: class {
    func didEntered(in position: FloatingViewPosition)
}
