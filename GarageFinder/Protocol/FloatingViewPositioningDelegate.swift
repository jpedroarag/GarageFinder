//
//  FloatingControllerDelegate.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 15/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol FloatingViewPositioningDelegate: class {
    func enteredPartialView()
    func enteredMiddleView()
    func enteredFullView()
    func shouldStopListeningToPanGesture() -> Bool
}
