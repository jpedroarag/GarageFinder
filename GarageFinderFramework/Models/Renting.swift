//
//  Renting.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct Renting: CustomCodable {
    public static var path: String = "/renting/"
    
    public var value: Float
    public var permanenceDuration: Int? // In minutes
    public let entryDate: Date
    public var exitDate: Date?
    
    public init() {
        value = 0
        permanenceDuration = nil
        entryDate = Date(timeIntervalSinceNow: 0)
        exitDate = nil
    }
    
    mutating func updatePermanenceDuration() {
        if let date = exitDate {
            let permanenceDurationInSeconds = date.timeIntervalSince(entryDate)
            self.permanenceDuration = Int((permanenceDurationInSeconds/60).rounded())
        } else {
            let currentDate = Date(timeIntervalSinceNow: 0)
            let permanenceDurationInSeconds = currentDate.timeIntervalSince(entryDate)
            self.permanenceDuration = Int((permanenceDurationInSeconds/60).rounded())
        }
    }
    
    mutating func updatePrice() {
        // TODO: Price business logic.
    }
    
    public mutating func update() {
        updatePermanenceDuration()
        updatePrice()
    }
    
    public mutating func conclude() {
        exitDate = Date(timeIntervalSinceNow: 0)
        update()
    }
    
    public var priceString: String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.decimalSeparator = ","
        formatter.currencyDecimalSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
    
    public var permanenceDurationString: String {
        guard let duration = permanenceDuration else { return "00:00" }
        let hours = Int(duration/60)
        let minutes = duration - (hours * 60)
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
    
    public var entryDateFormatted: String {
        return formattedDate(entryDate)
    }
    
    public var exitDateFormatted: String {
        return formattedDate(exitDate)
    }
    
    private func formattedDate(_ dateToFormat: Date?) -> String {
        guard let date = dateToFormat else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
