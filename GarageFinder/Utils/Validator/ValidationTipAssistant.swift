//
//  ValidationTipAssistant.swift
//  Itself
//
//  Created by Elias Paulino on 30/09/19.
//  Copyright © 2019 João Paulo de Oliveira Sabino. All rights reserved.
//

import Foundation

class ValidationTipAssistant {
    private var tips: [String: String] = [:]
    private(set) var registeredStrategies: [ValidationStrategy.Type] = []
    
    static var standart: ValidationTipAssistant = {
        let tipAssistant = ValidationTipAssistant()
        
        tipAssistant.addTip(forType: CPFValidationStrategy.self, tip: "* CPF Com Formato Inválido.")
        tipAssistant.addTip(forType: EmailValidationStrategy.self, tip: "* Email Inválido.")
        tipAssistant.addTip(forType: NumericDigititsLimitValidationStrategy.self, tip: "* Numero de Caracters Errado.")
        tipAssistant.addTip(forType: EmptyStrategy.self, tip: "* Campo não pode ser vazio.")
        tipAssistant.addTip(forType: NewPasswordValidationStrategy.self, tip: "* A senha está diferente.")
        tipAssistant.addTip(forType: PasswordCharLimitValidationStrategy.self, tip: "* A senha deve ter no mínimo 8 caracteres.")
        tipAssistant.addTip(forType: DriverLicenseValidationStrategy.self, tip: "* CNH Com Formato Inválido.")
        tipAssistant.addTip(forType: LicensePlateValidationStrategy.self, tip: "* Placa Com Formato Inválido.")

        return tipAssistant
    }()
    
    func addTip<Type: ValidationStrategy>(forType type: Type.Type, tip: String) {
        
        self.tips[String(describing: type)] = tip
        self.registeredStrategies.append(type)
    }
    
    func tip<Type: ValidationStrategy>(forType type: Type.Type) -> String? {
        return self.tips[String(describing: type)]
    }
    
    func tip(forType type: String) -> String? {
           return self.tips[type]
    }
}
