//
//  NetworkError.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case unknown
    case clientError(statusCode: Int, dataResponse: String)
    case serverError(statusCode: Int, dataResponse: String)
    case decodeError(String)
    case noJSONData
    case noticeError(String)
}
