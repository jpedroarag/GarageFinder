//
//  URLRequestExtension.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

extension URLRequest {
    
    init(service: Service) {
        if let urlComponents = URLComponents(service: service),
            let url = urlComponents.url {
            self.init(url: url)
            
            self.httpMethod = service.method.rawValue
            
            service.headers?.forEach { key, value in
                addValue(value, forHTTPHeaderField: key)
            }
            
            guard case let .requestParameters(payload) = service.task,
                service.parametersEncoding == .json else {
                    return
            }
            
            self.httpBody = payload.data
        } else {
            self.init(url: URL(fileURLWithPath: ""))
        }
    }
}
