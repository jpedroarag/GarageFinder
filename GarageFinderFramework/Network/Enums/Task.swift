//
//  Task.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

public enum Task {
    case requestPlain
    case requestParameters([String: Any])
    case requestWithBody(CustomCodable)
}
