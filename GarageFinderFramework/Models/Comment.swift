//
//  Comment.swift
//  GarageFinderFramework
//
//  Created by João Pedro Aragão on 20/09/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public struct Comment: CustomCodable {
    public static var path: String = "/comment/"
    
    public let commentId: Int
    public let fromUserId: Int
    public let toUserId: Int
    public let garageId: Int
    public let title: String
    public let message: String
    public let rating: Float
    
    public init(title: String, message: String, rating: Float) {
        self.title = title
        self.message = message
        self.rating = rating
        self.commentId = 0
        self.fromUserId = 0
        self.toUserId = 0
        self.garageId = 0
    }
}
