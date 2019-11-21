//
//  NotificationName+Extension.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 04/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//
import Foundation

extension Notification.Name {
    //notifies the menu scene to present an online game
    static let finishSearch = Notification.Name(rawValue: "finishSearch")
    static let adjustsMenu = Notification.Name(rawValue: "adjustsMenu")
    static let trafficSettingDidChange = Notification.Name(rawValue: "trafficSettingDidChange")
    static let mapOptionSettingDidChange = Notification.Name(rawValue: "mapOptionSettingDidChange")
}
