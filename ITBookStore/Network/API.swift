//
//  API.swift
//  ITBookStore
//
//  Created by Nick on 2021/12/24.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

protocol API {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var uri: String { get }
    
    associatedtype Parameter: ParameterConvertable
    associatedtype Response: ResponseConvertable
    
    func rxRequest(parameter: Parameter) -> Observable<Response>
    func request(parameter: Parameter, completion: @escaping(Swift.Result<Response, APIError>) -> Void)
}

extension API {
    var queue: DispatchQueue {
        DispatchQueue(label: "com.itbook.network", qos: .default, attributes: .concurrent)
    }
    
    func request(parameter: Parameter, completion: @escaping(Swift.Result<Response, APIError>) -> Void) {
        guard let apiBaseUrl = URL(string: baseUrl) else {
            completion(.failure(.networkError("Invalid base url")))
            return
        }
        
        guard let requestParam = try? parameter.asDictionary() else  {
            completion(.failure(.networkError("Invalid parameters")))
            return
        }
        
        let fullApiBaseUrl = apiBaseUrl.appendingPathComponent(uri)
        
        AF.request(fullApiBaseUrl, method: method, parameters: requestParam, encoding: URLEncoding.default)
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
    }
    
    func rxRequest(parameter: Parameter) -> Observable<Response> {
        return Observable<Response>.create { observer in
            request(parameter: parameter) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
