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
    
    private enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case clientUser = "from_user_id"
        case hostUser = "to_user_id"
        case garage = "garage_id"
        case title
        case message
        case rating
    }

    public init(id: Int? = nil, fromUser: User? = nil, toUser: User? = nil, garage: Garage? = nil, title: String?, message: String?, rating: Float?) {
        self.commentId = id
        self.clientUser = fromUser
        self.hostUser = toUser
        self.garage = garage
        self.title = title
        self.message = message
        self.rating = rating
    }
    
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try? container.decodeIfPresent(Int.self, forKey: .commentId)
        let title = try? container.decodeIfPresent(String.self, forKey: .title)
        let message = try? container.decodeIfPresent(String.self, forKey: .message)
        let rating = try? container.decodeIfPresent(Float.self, forKey: .rating)
        self.init(id: id, title: title, message: message, rating: rating)
        
        let fromUserId = try? container.decodeIfPresent(Int.self, forKey: .clientUser)
        let toUserId = try? container.decodeIfPresent(Int.self, forKey: .hostUser)
        let garageId = try? container.decodeIfPresent(Int.self, forKey: .garage)
        loadClientUser(fromUserId ?? -1)
        loadHostUser(toUserId ?? -1)
        loadGarage(garageId ?? -1)
    }
    
    func loadClientUser(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if clientUser != nil { return }
        // TODO: request user
        completion?()
    }
    
    func loadHostUser(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if hostUser != nil { return }
        // TODO: request user
        completion?()
    }
    
    func loadGarage(_ id: Int, _ completion: (() -> Void)? = nil) {
        if id < 0 { return }
        if garage != nil { return }
        // TODO: request address
        completion?()
    }
    
}
