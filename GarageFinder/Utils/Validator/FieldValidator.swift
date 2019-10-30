//
//  FieldValidator.swift
//  Itself
//
//  Created by Elias Paulino on 02/10/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import UIKit

protocol InValidationElement {
    var valueToValidate: String { get }
}

enum ValidationTipResult {
    case ok, wrong(String)
}

extension String: InValidationElement {
    var valueToValidate: String {
        return self
    }
}

extension UITextField: InValidationElement {
    var valueToValidate: String {
        return self.text ?? ""
    }
}

protocol InValidationElementWithWarningElement: InValidationElement {
    func setTip(_ tip: String)
    func hideTip()
}

extension GFTextField: InValidationElementWithWarningElement {
    func hideTip() {
        self.warningLabel.isHidden = true
    }
    
    func setTip(_ tip: String) {
        self.warningLabel.isHidden = false
        self.warningLabel.text = tip
    }
}

struct FieldValidator {
    private var tipAssistant: ValidationTipAssistant
    
    private var strategies: [String: ValidationStrategy] = [:]
            
    init(withTipAssistant tipAssistant: ValidationTipAssistant = .standart, andStrategies strategies: [ValidationStrategy]) {
        self.tipAssistant = tipAssistant
        
        self.strategies = Dictionary(uniqueKeysWithValues: strategies.map({ (strategy) -> (String, ValidationStrategy) in
            let strategyMirror = Mirror(reflecting: strategy)
            
            return (String(describing: strategyMirror.subjectType), strategy)
        }))
    }
    
    func validate<Type: ValidationStrategy>(
        element: InValidationElement,
        withStrategy strategy: Type.Type) -> ValidationTipResult {

        guard let strategyInstance = self.strategies[strategy.asString()] else {
            fatalError("Strategy must be registered on the validator")
        }

        switch strategyInstance.test(value: element.valueToValidate) {
        case .ok:
            return .ok
        case .wrong(let strategyType):
            guard let tip = tipAssistant.tip(forType: String(describing: strategyType)) else {
                fatalError("Strategy must be registered on the tipAssistent")
            }
            return .wrong(tip)
        }
    }
    
    func validate<Type: ValidationStrategy>(
        elements: InValidationElementWithWarningElement ...,
        withStrategy strategy: Type.Type) -> Bool {
        
        var isRight = false
        elements.forEach { element in
            let result: ValidationTipResult = validate(element: element, withStrategy: strategy)
            
            switch result {
            case .ok:
                element.hideTip()
                isRight = true
            case .wrong(let tip):
                element.setTip(tip)
                isRight = false
            }
        }
        return isRight
    }
}
