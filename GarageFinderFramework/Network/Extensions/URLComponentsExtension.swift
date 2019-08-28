//
//  URLComponentsExtension.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension URLComponents {
    
    init?(service: Service) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)
        
        guard case let .requestParameters(parameters) = service.task,
            service.parametersEncoding == .url else {
                return
        }

        self.queryItems = parameters.asDictionary.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
