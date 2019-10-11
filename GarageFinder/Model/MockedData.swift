//
//  MockedData.swift
//  GarageFinder
//
//  Created by João Pedro Aragão on 05/10/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import UIKit.UIImage

public struct MockedData {
    public static func loadMockedGarage(_ id: Int) -> Garage? {
        let bundle = Bundle.main
        guard let path = bundle.url(forResource: "GarageMock", withExtension: "json") else { return nil }
        if let data = try? Data(contentsOf: path, options: .mappedIfSafe) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let objects = try? decoder.decode([Garage].self, from: data)
            return objects?.filter({ $0.garageId == id }).first
        }
        return nil
    }
    
    public static func loadMockedGarages() -> [Garage]? {
        let bundle = Bundle.main
        guard let path = bundle.url(forResource: "GarageMock", withExtension: "json") else { return nil }
        if let data = try? Data(contentsOf: path, options: .mappedIfSafe) {
            let decoder = JSONDecoder()
            return try? decoder.decode([Garage].self, from: data)
        }
        return nil
    }
    
    public static func loadMockedUser(_ id: Int) -> User? {
        let bundle = Bundle.main
        guard let path = bundle.url(forResource: "UserMock", withExtension: "json") else { return nil }
        if let data = try? Data(contentsOf: path, options: .mappedIfSafe) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let objects = try? decoder.decode([User].self, from: data)
            return objects?.filter({ $0.userId == id }).first
        }
        return nil
    }
    
    static func loadMockedPictures() -> [UIImage?] {
        let image = UIImage(named: "mockGarage")
        return [image, image, image]
    }
}
