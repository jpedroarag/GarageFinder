//
//  NewPasswordValidationStrategy.swift
//  Itself
//
//  Created by Elias Paulino on 03/10/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

struct NewPasswordValidationStrategy: ValidationStrategy {
    var subStrategies: [ValidationStrategy] = [EmptyStrategy(), PasswordCharLimitValidationStrategy(limit: 6)]
    var oldPasswordTextField: GFTextField
    
    func validate(value: String) -> ValidationResult {
        if oldPasswordTextField.text != value {
            return .wrong(Self.self)
        }
        return .ok
    }
}
