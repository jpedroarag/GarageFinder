//
//  PlaceCategory.swift
//  GarageFinder
//
//  Created by João Paulo de Oliveira Sabino on 16/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit
import MapKit

public enum PlaceCategory: String {
    case home //Home
    case restaurant //Restaurant
    case gym //Active Life, Gym
    case grocery //Food, Grocery
    case hospital //Health & Medical, Hospital
    case education //Education. Colleges & Universities
    case hotel // Hotels & Travel, Hotels & Events
    case entertainanment //Arts & Entertainanment, Movie Theater
    case add = "plus"
    case other
    
    var icon: UIImage {
        return UIImage(named: self.rawValue) ?? UIImage()
    }
    
    var intEnum: PlaceCategoryIntEnum {
        switch self {
        case .home: return .home
        case .restaurant: return .restaurant
        case .gym: return .gym
        case .grocery: return .grocery
        case .hospital: return .hospital
        case .education: return .education
        case .hotel: return .hotel
        case .entertainanment: return .entertainanment
        case .add: return .add
        default: return .other
        }
    }
}

@objc public enum PlaceCategoryIntEnum: Int16 {
    case home //Home
    case restaurant //Restaurant
    case gym //Active Life, Gym
    case grocery //Food, Grocery
    case hospital //Health & Medical, Hospital
    case education //Education. Colleges & Universities
    case hotel // Hotels & Travel, Hotels & Events
    case entertainanment //Arts & Entertainanment, Movie Theater
    case add
    case other
    
    var stringEnum: PlaceCategory {
        switch self {
        case .home: return .home
        case .restaurant: return .restaurant
        case .gym: return .gym
        case .grocery: return .grocery
        case .hospital: return .hospital
        case .education: return .education
        case .hotel: return .hotel
        case .entertainanment: return .entertainanment
        case .add: return .add
        default: return .other
        }
    }
}
