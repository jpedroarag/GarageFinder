//
//  Date+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 24/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
