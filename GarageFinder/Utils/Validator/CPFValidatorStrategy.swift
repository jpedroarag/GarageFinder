//
//  CPFValidatorStrategy.swift
//  Itself
//
//  Created by Elias Paulino on 30/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

enum ValidationResult {
    
    case ok, wrong(ValidationStrategy.Type)
}

struct NumericDigititsLimitValidationStrategy: ValidationStrategy {
    var limit: Int
    var subStrategies: [ValidationStrategy] = []
    
    func validate(value: String) -> ValidationResult {
        let numbers = value.compactMap { (char) -> Int? in
            return char.wholeNumberValue
        }
        
        if numbers.count == 0 {
            return .ok
        }
        
        guard numbers.count == limit && !numbers.allElementsAreEqual else {
            return .wrong(Self.self)
        }
      
        return .ok
    }
}

struct CPFValidationStrategy: ValidationStrategy {
    var subStrategies: [ValidationStrategy] = [NumericDigititsLimitValidationStrategy(limit: 11)]
    
    func validate(value: String) -> ValidationResult {
        let numbers = value.compactMap { (char) -> Int? in
            return char.wholeNumberValue
        }
        
        let digitVerifier1 = digitCalculator(numbers.prefix(9))
        let digitVerifier2 = digitCalculator(numbers.prefix(10))
        if numbers.count > 0 {
            if digitVerifier1 == numbers[9] && digitVerifier2 == numbers[10] {
                return .ok
            }
        } else {
            return .ok
        }
        return .wrong(Self.self)
    }
    
    private func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
        var number = slice.count + 2
        
        let digit = 11 - slice.reduce(0, { (total, currentValue) -> Int in
            number -= 1
            return total + currentValue * number
        }) % 11

        return digit % 10
    }
}

extension Array where Element: Hashable {
    var allElementsAreEqual: Bool {
        return Set(self).count == 1
    }
}
