//
//  DocumentType.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 23/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public enum DocumentType: String, CustomCodable {
    public static var path: String = "/documentType/"
    
    case cpf
    case rg
}
