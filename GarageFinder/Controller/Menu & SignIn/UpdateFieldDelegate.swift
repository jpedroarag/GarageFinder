//
//  UpdateFieldDelegate.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 30/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

protocol UpdateFieldDelegate: class {
    func didUpdate(field: TextFieldType, content: String?)
}
