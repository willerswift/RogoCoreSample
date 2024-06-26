//
//  NetworkClient.swift
//  TestSDK
//
//  Created by ANh Tuan on 20/08/2023.
//

import Foundation
class NetworkClient {
    
    static var shared = NetworkClient()
    
    func callApi(url: URL,
                 method: HttpRequestMethod = .get,
                 headers: [String: String]? = nil,
                 parameters: [String: Any]?,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                let body = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = body
            } catch {
                completion(nil, nil, error)
                return
            }
        }
        
        request.allHTTPHeaderFields = [:]
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            completion(data, response, error)
        }
        
        task.resume()
    }
}

extension NetworkClient {
    func handleDecodeResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: ((_ info: T?, _ error: Error?)->())?) {
        if error != nil {
            completion?(nil, error) // TODO: handle error
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.handleNetworkResponse(response)
            switch result {
            case .failureWithError:
                break
            case .success:
                guard let responseData = data else {
                    completion?(nil, UIError.custom(message: ".noData."))
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                    completion?(apiResponse,nil)
                } catch {
                    print(error)
                    completion?(nil,
                               UIError.custom(message: ".unableToDecode."))
                }
            case .failure(let networkFailureError):
                completion?(nil, UIError.custom(message: networkFailureError))
            }
        }
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse) -> NewtworkResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 400: return .failureWithError
        case 401: return .failure("authenticationError")
        case 404...599: return .failure("badRequest")
        case 600: return .failure("outdated")
        default: return .failure(".failed.")
        }
    }
    
    enum NewtworkResult<String>{
        case success
        case failure(String)
        case failureWithError
    }
    
    public enum UIError: LocalizedError {
        
        case undefinedAuthMethod
        case unAuthenticated
        case custom(message: String)
    }
}


typealias JSONParams = [String : Any]

enum HttpRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
