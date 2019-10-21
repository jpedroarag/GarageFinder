//
//  Result.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 16/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct Response<T: CustomCodable>: Codable {
    public let result: T?
    public let results: [T]?
    public let status: String?
    public let notice: String?
    public let jwt: String?
}
