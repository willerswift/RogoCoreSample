//
//  AuthenHandler.swift
//  TestSDK
//
//  Created by ANh Tuan on 20/08/2023.
//

import Foundation
import RogoCore

public let RG_ACCESS_TOKEN_KEY = "rg_remember_rogo_access_token"
class AuthenHandler: RGBiAuth {
    // Singleton
    static var shared = AuthenHandler()
    
    // Adap RGBiAuth
    func isAuthenticated(_ method: RGBAuthMethod) -> Bool {
        return UserDefaults.standard.string(forKey: RG_ACCESS_TOKEN_KEY) != nil
    }
    
    func getAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
        completion(UserDefaults.standard.string(forKey: RG_ACCESS_TOKEN_KEY), nil)
    }
    
    func refreshAccessToken(_ method: RGBAuthMethod, completion: @escaping RGBCompletionObject<String?>) {
        
    }
    
}
