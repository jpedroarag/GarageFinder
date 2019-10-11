//
//  GarageService.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public enum NetworkService<T: CustomCodable>: Service {
    
    case get(T.Type, id: Int?)
    case add(T)
    case update(T)
    case login(T)
    case logout(T)
    
    public var baseURL: URL {
        let url = "https://jsonplaceholder.typicode.com"
        return URL(string: url) ?? URL(fileURLWithPath: "")
    }

    //TODO: Get real paths from API
    public var path: String {
        switch self {
        case .get(let type, let id):
            return id == nil ? type.path : "\(type.path)\(id ?? 0)"
        case .add(let item), .update(let item):
            return type(of: item).path
        case .login:
            return "/.../"
        case .logout:
            return "/.../"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .add, .login, .logout:
            return .post
        case .update:
            return .patch
        }
    }
    
    public var task: Task {
        switch self {
        case .get:
            return .requestPlain
        case .add(let item), .update(let item), .login(let item), .logout(let item):
            return .requestWithBody(item)
        }
    }
    
    public var headers: Headers? {
        switch self {
        case .get:
            return nil
        case .add, .login, .logout, .update:
            return ["Content-type": "application/json"]
        }
    }
    
    public var parametersEncoding: ParametersEncoding {
        switch self {
        case .get:
            return .url
        case .add, .login, .logout, .update:
            return .json
        }
    }
    
}

public extension URLSessionProvider {
    func request<T: Decodable>(_ service: NetworkService<T>,
                               completion: @escaping (Result<T, Error>) -> Void) {
        self.request(type: T.self, service: service, completion: completion)
    }
}
