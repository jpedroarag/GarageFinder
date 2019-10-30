//
//  EmptyValidationStrategy.swift
//  Itself
//
//  Created by Elias Paulino on 30/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

struct EmptyStrategy: ValidationStrategy {
    var subStrategies: [ValidationStrategy] = []
    
    func validate(value: String) -> ValidationResult {
        if !value.isEmpty && value != " " {
            return .ok
        }
        return .wrong(Self.self)
    }
}
