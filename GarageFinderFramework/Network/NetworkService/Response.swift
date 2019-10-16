//
//  Result.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct Response<T: CustomCodable>: Codable {
    let result: T
    let status: String?
    let notice: String?
}
