//
//  Comment.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public class Comment: Decodable {
    public var commentId: Int!
    public var clientUser: User!
    public var hostUser: User!
    public var garage: Garage!
    public var title: String!
    public var message: String!
    public var rating: Float!

    public init(id: Int? = nil, fromUser: User? = nil, toUser: User? = nil, garage: Garage? = nil, title: String?, message: String?, rating: Float?) {
        self.commentId = id
        self.clientUser = fromUser
        self.hostUser = toUser
        self.garage = garage
        self.title = title
        self.message = message
        self.rating = rating
    }
    
}
