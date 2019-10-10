//
//  CustomCodable.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 10/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

public protocol CustomCodable: Codable {
    static var path: String {get}
}
