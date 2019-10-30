//
//  ValidateStrategy.swift
//  Itself
//
//  Created by Elias Paulino on 30/09/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

protocol ValidationStrategy {
    var subStrategies: [ValidationStrategy] { get set }
    func validate(value: String) -> ValidationResult
    func test(value: String) -> ValidationResult
}

extension ValidationStrategy {
        
    func validateSubStrategies(value: String) -> ValidationResult {
        for strategy in subStrategies {
            if case let .wrong(strategy) = strategy.test(value: value) {
                return .wrong(strategy)
            }
        }
        return .ok
    }
    
    func test(value: String) -> ValidationResult {
        switch validateSubStrategies(value: value) {
        case .ok:
            return validate(value: value)
        case .wrong(let strategy):
            return .wrong(strategy)
        }
    }
    
    static func asString() -> String {
        return String(describing: Self.self)
    }
}
