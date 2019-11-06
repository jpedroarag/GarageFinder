//
//  Comment.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import GarageFinderFramework

public class Comment: Codable {
    public var commentId: Int!
    public var clientUserId: Int!
    public var hostUserId: Int!
    public var garage: Garage!
    public var title: String!
    public var message: String!
    public var rating: Float!

    public init(id: Int? = nil, fromUserId: Int? = nil, toUserId: Int? = nil, garage: Garage? = nil, title: String?, message: String?, rating: Float?) {
        self.commentId = id
        self.clientUserId = fromUserId
        self.hostUserId = toUserId
        self.garage = garage
        self.title = title
        self.message = message
        self.rating = rating
    }
    
}
