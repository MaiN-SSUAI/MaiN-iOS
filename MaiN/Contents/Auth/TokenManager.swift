//
//  TokenManager.swift
//  MaiN
//
//  Created by 김수민 on 5/21/24.
//

import Foundation
import Moya

class TokenManager {
    static let shared = TokenManager()
    private let provider = MoyaProvider<AuthAPI>()

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
        UserDefaults.standard.removeObject(forKey: "isAutoLogin")
    }
    
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let accessToken = accessToken, let refreshToken = refreshToken else {
            completion(false)
            return
        }
        
        provider.request(.refreshAccessToken(accessToken: accessToken, refreshToken: refreshToken)) { result in
            print("access확인: 🍀\(accessToken)")
            print("refresh확인: 🍀\(refreshToken)")
            switch result {
            case .success(let response):
                if response.statusCode == 400 {
                    print("🚨토큰 재발급 네트워크 실패: 상태 코드 400 -> refresh 토큰 만료")
                    completion(false)
                    return
                }
                do {
                    if let json = try response.mapJSON() as? [String: Any],
                       let newAccessToken = json["accessToken"] as? String,
                       let newRefreshToken = json["refreshToken"] as? String {
                        print("🚨토큰 재발급 네트워크 성공")
                        self.accessToken = newAccessToken
                        self.refreshToken = newRefreshToken
                        print("access확인2 \(self.accessToken)")
                        print("refresh확인2 \(self.refreshToken)")
                        completion(true)
                    } else {
                        print("🚨토큰 재발급 네트워크 옵셔널처리 실패")
                        completion(false)
                    }
                } catch {
                    print("🚨토큰 재발급 네트워크 매핑 실패")
                    completion(false)
                }
            case .failure(let error):
                print("🚨토큰 재발급 네트워크 실패")
                completion(false)
            }
        }
    }
    
    func isRefreshTokenExpired() -> Bool {
        return true
    }
}
