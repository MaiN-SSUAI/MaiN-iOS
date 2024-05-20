//
//  TokenManager.swift
//  MaiN
//
//  Created by 김수민 on 5/21/24.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() { }
    
    var accessToken: String? {
        get {
            UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "accessToken")
        }
    }
    
    var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "refreshToken")
        }
    }
    
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}

