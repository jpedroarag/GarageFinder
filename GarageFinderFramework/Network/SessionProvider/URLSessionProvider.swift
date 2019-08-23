//
//  URLSessionProvider.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public final class URLSessionProvider: Provider {
    
    private var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(type: T.Type,
                                      service: Service,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(service: service)
        let task = self.session.dataTask(with: request) { (result) in
            self.handleResult(result: result, completion: completion)
        }
        
        task.resume()
    }
    
    private func handleResult<T: Decodable>(result: Result<(URLResponse, Data), Error>,
                                            completion: (Result<T, Error>) -> Void) {
        switch result {
        case .failure(let error):
            print("\n\n\nerror\(error)\n\n\n")
            completion(.failure(error))
        case .success(let response, let data):
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(NetworkError.noJSONData))
            }
            switch httpResponse.statusCode {
            case 200...299:
                guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                    return completion(.failure(NetworkError.unknown))
                }
                
                completion(.success(model))
            default:
                completion(.failure(NetworkError.unknown))
            }
            
        }
        
    }
}
