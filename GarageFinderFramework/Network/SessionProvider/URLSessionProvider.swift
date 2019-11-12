//
//  URLSessionProvider.swift
//  GarageFinderFramework
//
//  Created by João Paulo de Oliveira Sabino on 23/08/19.
//  Copyright © 2019 João Pedro Aragão. All rights reserved.
//

import Foundation

public final class URLSessionProvider {
    
    private var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<G: Service>(service: G,
                                    completion: @escaping (Result<Response<G.CustomType>, Error>) -> Void) {
        
        let request = URLRequest(service: service)
        print("REQUEST:", request)
        let task = self.session.dataTask(with: request) { (result) in
            self.handleResult(result: result, completion: completion)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }
    
    private func handleResult<T: Decodable>(result: Result<(URLResponse, Data), Error>,
                                            completion: (Result<Response<T>, Error>) -> Void) {
        switch result {
        case .failure(let error):
            print("\n\n\nerror\(error)\n\n\n")
            completion(.failure(error))
        case .success(let response, let data):
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(NetworkError.noJSONData))
            }
            guard let dataString = String(bytes: data, encoding: .utf8) else { return }
            print("DATA: ", dataString)
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.calendar = .init(identifier: .iso8601)
                formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
                decoder.dateDecodingStrategy = .formatted(formatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                do {
                    let model = try decoder.decode(Response<T>.self, from: data)
                    if let notice = model.notice {
                        completion(.failure(NetworkError.noticeError(notice)))
                    } else {
                        completion(.success(model))
                    }

                } catch {
                    print("DECODE ERROR: \(error)")
                    completion(.failure(NetworkError.decodeError(error.localizedDescription)))
                }
                
            case 400...499:
                completion(.failure(NetworkError.clientError(statusCode: httpResponse.statusCode, dataResponse: dataString)))
            case 500...599:
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode, dataResponse: dataString)))
            default:
                completion(.failure(NetworkError.unknown))
            }
            
        }
        
    }
}
