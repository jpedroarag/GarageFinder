//
//  NumberFormatter+Extension.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 05/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static func getPriceString(currencySymbol: String = "R$", value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.decimalSeparator = ","
        formatter.currencyDecimalSeparator = ","
        formatter.currencySymbol = currencySymbol
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value).replacingOccurrences(of: ".", with: ",")
    }
}
