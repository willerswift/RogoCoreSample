//
//  FptRequest.swift
//  TestSDK
//
//  Created by ANh Tuan on 20/08/2023.
//

import Foundation
import CryptoKit

let fptDomainUrl = URL(string: "https://api-fptlife-stag.fptsmarthome.vn/api/v1.2/public/")!
let fptApiKey = "VcCQiu6@wenQ>4w|5ri@a"
extension NetworkClient {
    func login(phone: String,
               password: String,
               countryCode: String = "VN",
               completion: ((_ info: FphLoginResponse?, _ error: Error?)->())?){
        let url = fptDomainUrl.appending(path: "auth/login")
        let params = ["phone": phone,
                      "password": password,
                      "country_code": countryCode]
        let headers = ["x-api-key": "\(fptApiKey)"]
        self.callApi(url: url,
                     method: .post,
                     headers: headers,
                     parameters: params) { data, response, error in
            self.handleDecodeResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func generateRogoToken(fptToken: String,
                           completion: ((_ info: RequestGenRogoTokenResponse?, _ error: Error?)->())?){
        let url = fptDomainUrl.appending(path: "rogo_auth/gen_login_token")
        let headers = ["x-api-key": "\(fptApiKey)",
                       "Authorization":"Bearer \(fptToken)"]
        let params: JSONParams = [:]
        self.callApi(url: url,
                     method: .post,
                     headers: headers,
                     parameters: params) { data, response, error in
            self.handleDecodeResponse(data: data, response: response, error: error, completion: completion)
        }
    }
    
    func getRogoToken(session: FptRogoSession,
                      completion: ((_ info: RequestGenRogoTokenResponse?, _ error: Error?)->())?){
        
        guard let e = session.e,
              let i = session.i else {
            return
        }

        let data = "https://api-fptlife-stag.fptsmarthome.vn/api/v1.2/public/get_session_data\(e)\(i)".data(using: .utf8)!
        let s = data.md5()
        var base64EncodedString = s.base64EncodedString(options: .endLineWithLineFeed)
        
        base64EncodedString = base64EncodedString.replacingOccurrences(of: "+", with: "-")
        base64EncodedString = base64EncodedString.replacingOccurrences(of: "/", with: "_")
        base64EncodedString = base64EncodedString.replacingOccurrences(of: "=", with: "")
        
        
        let params = [
            URLQueryItem(name: "e", value: "\(session.e!)"),
            URLQueryItem(name: "i", value: session.i!),
            URLQueryItem(name: "s", value: base64EncodedString)
        ]
        
        let url = fptDomainUrl.appending(path: "get_session_data")
            .appending(queryItems: params)

        
        let headers = ["x-api-key": "\(fptApiKey)",
                       "e": "\(session.e ?? 0)",
                       "i": session.i ?? "",
                       "s": base64EncodedString]
        
        
        self.callApi(url: url,
                     headers: headers,
                     parameters: nil) { data, response, error in
            self.handleDecodeResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}


// MARK: - Response models
struct FphLoginResponse: Codable {
    let fshLoginResponseData: FshLoginResponseData?
    let errorCode: Int?
    let message: String?
    let statusCode: Int?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case fshLoginResponseData = "data"
        case errorCode = "error_code"
        case message, statusCode, time
    }
}

// MARK: - FshLoginResponseData
struct FshLoginResponseData: Codable {
    let accessToken, accessTokenType: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessTokenType = "access_token_type"
    }
}

// MARK: - RequestGenRogoTokenResponse
struct RequestGenRogoTokenResponse: Codable {
    let statusCode: Int?
    let message, time: String?
    let data: RequestGenRogoTokenResponseData?
}

// MARK: - RequestGenRogoTokenResponseClass
struct RequestGenRogoTokenResponseData: Codable {
    let session: FptRogoSession?
    let rogoToken: String?
    let isNewUser: Bool?
    
    enum CodingKeys: String, CodingKey {
        case session
        case rogoToken = "loginToken"
        case isNewUser
    }
}

// MARK: - RogoSession
struct FptRogoSession: Codable {
    let i: String?
    let e: Int?
}
