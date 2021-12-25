//
//  API.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation
import Alamofire

protocol API {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var uri: String { get }
    
    associatedtype Parameter: ParameterConvertable
    associatedtype Response: ResponseConvertable
    
    func request(parameter: Parameter, completion: @escaping(Swift.Result<Response, APIError>) -> Void) -> Cancellable?
}

extension API {
    var queue: DispatchQueue {
        DispatchQueue(label: "com.itbook.network", qos: .default, attributes: .concurrent)
    }
    
    @discardableResult
    func request(parameter: Parameter, completion: @escaping(Swift.Result<Response, APIError>) -> Void) -> Cancellable? {
        guard let apiBaseUrl = URL(string: baseUrl) else {
            completion(.failure(.networkError("Invalid base url")))
            return nil
        }
        
        guard let requestParam = try? parameter.asDictionary() else  {
            completion(.failure(.networkError("Invalid parameters")))
            return nil
        }
        
        let fullApiBaseUrl = apiBaseUrl.appendingPathComponent(uri)
        
        let request = AF.request(fullApiBaseUrl, method: method, parameters: requestParam, encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: Response.self, queue: queue) { response in
                switch response.result {
                case .success(let value):
                    if value.isSuccess {
                        completion(.success(value))
                    } else {
                        completion(.failure(.apiError("API Error : code \(value.apiErrorCode ?? "")")))
                    }
                case .failure(let error):
                    completion(.failure(.networkError(error.localizedDescription)))
                }
            }
        return request
    }
}


extension Alamofire.Request: Cancellable {}
