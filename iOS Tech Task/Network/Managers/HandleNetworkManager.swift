//
//  HandleNetworkManager.swift
//  iOS Tech Task
//
//  Created by Ammar on 3/24/21.
//  Copyright © 2021 Ammar. All rights reserved.
//

import Foundation
import Moya

protocol HandleNetworkManager {
    func handleNetworkResponse<T: Codable>(result: (Result<Moya.Response, MoyaError>), completion: (DataResult<T>)  -> Void, isList: Bool?)
    func parsingResponse<T: Codable>(_ response: Response, completion: (DataResult<T>)  -> Void, isList: Bool?)
}


extension HandleNetworkManager {
    func handleNetworkResponse<T: Codable>(result: (Result<Moya.Response, MoyaError>), completion: (DataResult<T>)  -> Void, isList: Bool? = false) {
        switch result {
        case .success(let response):
            parsingResponse(response, completion: completion, isList: isList)
        case .failure(let error):
            completion(.failure(error))
        }
    }


    func parsingResponse<T: Codable>(_ response: Response, completion: (DataResult<T>)  -> Void, isList: Bool? = false) {
        guard let responseString = String(data: response.data, encoding: .utf8) else {
            completion(.failure(APIError.parsing))
            return
        }
        let jsonData = Data(responseString.utf8)
        let decoder = JSONDecoder()
        
        switch response.statusCode {
             case 200...299:
                if isList! {
                    do {
                        let data = try decoder.decode([T].self, from: jsonData)
                        completion(.success(nil, data))
                     } catch {
                        completion(.failure(APIError.mapping))
                     }
                } else {
                    do {
                         let data = try decoder.decode(T.self, from: jsonData)
                         completion(.success(data, nil))
                      } catch {
                         completion(.failure(APIError.mapping))
                      }
                }

             case 400...499:
                let data = try! decoder.decode(DefaultResponse.self, from: jsonData)
                completion(.failure(APIError.severError(data.message ?? "Server Error")))
                
             case 500...599: completion(.failure(APIError.severError(NetworkResponse.badRequest.rawValue)))
             case 600: completion(.failure(APIError.severError(NetworkResponse.outdated.rawValue)))
             default: completion(.failure(APIError.severError(NetworkResponse.failed.rawValue)))
        }
    }

}


