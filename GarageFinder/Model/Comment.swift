//
//  Comment.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public class Comment: CustomCodable {
    public static var path: String = "/api/v1/comments/"
    
    public var id: Int!
    public var fromUserId: Int!
    public var toUserId: Int!
    public var garageId: Int!
    public var title: String!
    public var message: String!
    public var rating: Float!

    public init(id: Int? = nil, fromUserId: Int? = nil, toUserId: Int? = nil, garageId: Int? = nil, message: String?, rating: Float?) {
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.garageId = garageId
        self.title = CommentType(rating: rating ?? 3)?.rawValue
        self.message = message
        self.rating = rating
    }
    
}

enum CommentType: String {
    case awesomeHost = "Ótima garagem"
    case goodHost = "Boa garagem"
    case averageHost = "Garagem ok"
    case badHost = "Garagem ruim"
    case awfulHost = "Terrível"
    
    init?(rating: Float) {
        var value: String
        switch rating {
        case 5:
            value = CommentType.awesomeHost.rawValue
        case 4:
            value = CommentType.goodHost.rawValue
        case 3:
            value = CommentType.averageHost.rawValue
        case 2:
            value = CommentType.badHost.rawValue
        case 1:
            value = CommentType.awfulHost.rawValue
        default:
            value = ""
        }
        self.init(rawValue: value)
    }
}
