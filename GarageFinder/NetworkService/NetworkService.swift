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
            case is Renting.Type:
                return "/api/v1/user_parking?show=current/"
            default:
                return ""
            }
        case .get(let type, let id):
            if type is Renting.Type && id == nil {
                return "/api/v1/user_parking/"
            } else if let id = id {
                return "\(type.path)\(id)"
            } else {
                return type.path
            }            
        case .post(let item), .update(let item):
            return type(of: item).path
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .get, .getCurrent:
            return .get
        case .post, .update:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .get, .getCurrent:
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
            case is Renting.Type:
                return ["Content-type": "application/json", "Authorization": UserDefaults.token]
            default:
                return nil
            }
        case .post(let item):
            switch item {
            case is Vehicle:
                return ["Content-type": "application/json", "Authorization": UserDefaults.token]
            default:
                return ["Content-type": "application/json"]
            }
        case .update:
            return ["Content-type": "application/json"]
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
