//
//  Renting.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct Parking: CustomCodable {
    public static var path: String = "/renting/"
    
    public let id: Int
    public let garageOwnerId: Int
    public let driverId: Int
    public let licensePlate: String
    public let vehicleId: Int
    public let garageId: Int
    
    public var price: Float
    public var permanenceDuration: Int? // In minutes
    public let start: Date
    public var end: Date?
    
    public init(id: Int,
                garageOwnerId: Int,
                driverId: Int,
                licensePlate: String,
                vehicleId: Int,
                garageId: Int) {
        self.id = id
        self.garageOwnerId = garageOwnerId
        self.driverId = driverId
        self.licensePlate = licensePlate
        self.vehicleId = vehicleId
        self.garageId = garageId
        self.price = 12
        self.permanenceDuration = nil
        self.start = Date()
        self.end = nil
    }
    
    public init() {
        self.init(id: 5, garageOwnerId: 1, driverId: 1, licensePlate: "OCB-2913", vehicleId: 1, garageId: 4)
    }
    
    mutating func updatePermanenceDuration() {
        let referenceDate = end ?? Date()
        let permanenceDuration = referenceDate.timeIntervalSince(start)/60
        self.permanenceDuration = Int(permanenceDuration.rounded())
    }
    
    mutating func updatePrice() {
        // TODO: Price business logic
    }
    
    public mutating func update() {
        updatePermanenceDuration()
        updatePrice()
    }
    
    public mutating func conclude() {
        end = Date()
        update()
    }
    
    public func priceString() -> String {
        return NumberFormatter.getPriceString(currencySymbol: "", value: Double(price))
    }
    
    public func permanenceDurationString() -> String {
        guard let duration = permanenceDuration else { return "00:00" }
        let hours = Int(duration/60)
        let minutes = duration - (hours * 60)
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        return "\(hoursString):\(minutesString)"
    }
    
    public func entryDate() -> String {
        return formattedDate(start)
    }
    
    public func exitDate() -> String {
        return formattedDate(end)
    }
    
    private func formattedDate(_ dateToFormat: Date?) -> String {
        guard let date = dateToFormat else { return "--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: date)
    }
}