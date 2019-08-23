//
//  GarageService.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public enum GarageService: Service {
    
    case comment(id: Int)
    case posts(post: MockPost)
    
    public var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com") ?? URL(fileURLWithPath: "")
    }
    
    public var path: String {
        switch self {
        case .comment(let id):
            return "/comments/\(id)"
        case .posts:
            return "/posts"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .comment:
            return .get
        case .posts:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .comment:
            return .requestPlain
        case .posts(let post):
            return .requestParameters(post)
        }
    }
    
    public var headers: Headers? {
        switch self {
        case .comment:
            return nil
        case .posts:
            return ["Content-type": "application/json; charset=UTF-8"]
        }
    }
    
    public var parametersEncoding: ParametersEncoding {
        switch self {
        case .comment:
            return .url
        case .posts:
            return .json
        }
    }
    
}

public struct MockComment: Decodable {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct MockPost: Codable {
    public let id: Int
    public let title: String
    public let body: String
    
    public init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}
