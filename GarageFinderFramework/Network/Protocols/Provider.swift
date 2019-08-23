//
//  Provider.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

protocol Provider {
    func request<T: Decodable>(type: T.Type, service: Service,
                               completion: @escaping (Result<T, Error>) -> Void)
}
