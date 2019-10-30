//
//  GarageService.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation
import GarageFinderFramework

public enum NetworkService<T: CustomCodable>: Service {
    public typealias CustomType = T
    
    case getCurrent(T.Type)
    case get(T.Type, id: Int? = nil)
    case post(T)
    case update(T)
    
    public var baseURL: URL {
        let url = "https://garagefinderapi.herokuapp.com"
        return URL(string: url) ?? URL(fileURLWithPath: "")
    }

    public var path: String {
        switch self {
        case .getCurrent(let item):
            switch item {
            case is User.Type:
                return "/api/v1/current_user/"
            case is Parking.Type:
                return "/api/v1/user_parking/"
            default:
                return ""
            }
        case .get(let type, let id):
            if type is Parking.Type && id == nil {
                return "/api/v1/user_parking/"
            } else if let id = id {
                return "\(type.path)\(id)"
            } else {
                return type.path
            }            
        case .post(let item), .update(let item):
            if let object = item as? Parking, let parkingId = object.id {
                return "\(type(of: item).path)\(parkingId)"
            } else if let object = item as? User, let userId = object.id {
                return "\(type(of: item).path)\(userId)"
            }
            return type(of: item).path
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .get, .getCurrent:
            return .get
        case .post:
            return .post
        case .update:
            return .patch
        }
    }
    
    public var task: Task {
        switch self {
        case .getCurrent(let item):
            if item is Parking.Type {
                return .requestParameters(["show": "current"])
            }
            return .requestPlain
        case .get:
            return .requestPlain
        case .post(let item), .update(let item):
            return .requestWithBody(item)
        }
    }
    
    public var headers: Headers? {
        switch self {
        case .get(let item, _), .getCurrent(let item):
            switch item {
            case is Vehicle.Type, is User.Type:
                return ["Content-type": "application/json", "Authorization": UserDefaults.token]
            case is Parking.Type:
                return ["Content-type": "application/json", "Authorization": UserDefaults.token]
            default:
                return nil
            }
        case .post(let item):
            switch item {
            case is Vehicle, is Parking:
                return ["Content-type": "application/json", "Authorization": UserDefaults.token]
            default:
                return ["Content-type": "application/json"]
            }
        case .update:
            return ["Content-type": "application/json", "Authorization": UserDefaults.token]
        }
    }
    
    public var parametersEncoding: ParametersEncoding {
        switch self {
        case .get, .getCurrent:
            return .url
        case .post, .update:
            return .json
        }
    }
}

public extension URLSessionProvider {
    func request<T: Decodable>(_ service: NetworkService<T>,
                               completion: @escaping (Result<Response<T>, Error>) -> Void) {
        
        self.request(service: service, completion: completion)
    }
}
