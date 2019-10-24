//
//  CoreDataError.swift
//  CBL
//
//  Created by Ada 2018 on 31/08/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

enum CoreDataManagerError : Error {
    case noContainer
    var localizedDescription : String {
        switch self {
        case .noContainer:
            return "There is no persistent container"
        }
    }
}
