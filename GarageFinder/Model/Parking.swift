//
//  Renting.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 25/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public struct Parking: CustomCodable {
    public static var path: String = "/api/v1/parkings/"
    
    public var id: Int?
    public let garageOwnerId: Int?
    public let driverId: Int?
    public let licensePlate: String?
    public let vehicleId: Int?
    public let garageId: Int?
    
    public var price: Float?
    public var pricePerHour: Float?
    public var permanenceDuration: Int? // In minutes
    public var start: Date?
    public var end: Date?
    public var status: Bool?

    public init(id: Int? = nil,
                garageOwnerId: Int? = nil,
                driverId: Int? = nil,
                licensePlate: String? = "XXXX-000",
                vehicleId: Int? = 0,
                garageId: Int? = nil,
                pricePerHour: Float? = nil,
                status: Bool? = nil) {
        self.id = id
        self.garageOwnerId = garageOwnerId
        self.driverId = driverId
        self.licensePlate = licensePlate
        self.vehicleId = vehicleId
        self.garageId = garageId
        self.price = 0
        self.pricePerHour = price
        self.permanenceDuration = nil
        self.start = nil
        self.end = nil
        self.status = status
    }
    
    mutating func fire() {
        start = Date()
    }
    
    mutating func updatePermanenceDuration() {
        let referenceDate = end ?? Date()
        let permanenceDuration = referenceDate.timeIntervalSince(start ?? Date())/60
        self.permanenceDuration = Int(permanenceDuration.rounded())
    }
    
    mutating func updatePrice() {
        guard let permanence = permanenceDuration, let pricePerHour = pricePerHour else { return }
        let pricePerMinute = pricePerHour/60
        let actualPrice = pricePerMinute * Float(permanence)
        self.price = actualPrice == 0 ? pricePerMinute : actualPrice
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
        return NumberFormatter.getPriceString(currencySymbol: "", value: Double(price ?? 0.0))
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
