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
    case postComment(comment: MockComment)
    
    public var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com") ?? URL(fileURLWithPath: "")
    }
    
    public var path: String {
        switch self {
        case .comment(let id):
            return "/comments/\(id)"
        case .posts:
            return "/posts"
        case .postComment:
            return "/comments"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .comment:
            return .get
        case .posts, .postComment:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .comment:
            return .requestPlain
        case .posts(let post):
            return .requestParameters(post)
        case .postComment(let comment):
            return .requestParameters(comment)
        }
    }
    
    public var headers: Headers? {
        switch self {
        case .comment:
            return nil
        case .posts, .postComment:
            return ["Content-type": "application/json; charset=UTF-8"]
        }
    }
    
    public var parametersEncoding: ParametersEncoding {
        switch self {
        case .comment:
            return .url
        case .posts, .postComment:
            return .json
        }
    }
    
}

public struct MockComment: Codable {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct MockPost: Codable {
    public let userId: Int
    public let title: String
    public let body: String
    
    public init(userId: Int, title: String, body: String) {
        self.userId = userId
        self.title = title
        self.body = body
    }
}
