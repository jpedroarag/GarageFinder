//
//  CharactersLimitValidationStrategy.swift
//  Itself
//
//  Created by Elias Paulino on 03/10/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

struct PasswordCharLimitValidationStrategy: ValidationStrategy {
    var limit: Int = 6
    var subStrategies: [ValidationStrategy] = [EmptyStrategy()]
    
    func validate(value: String) -> ValidationResult {
        if value.count >= limit {
            return .ok
        }
        return .wrong(Self.self)
    }
}
