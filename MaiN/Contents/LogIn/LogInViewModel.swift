//
//  LogInViewModel.swift
//  MaiN
//
//  Created by 김수민 on 5/21/24.
//

import SwiftUI
import Moya

class LogInViewModel: ObservableObject {
    private let provider = MoyaProvider<LogInAPI>()
    //MARK: Publisheed
    @Published var loginSuccess: Bool = false
    @Published var isAuthenticating: Bool = false
    @Published var goToLogIn: Bool = false
    @Published var showAlert: Bool = false

    @Published var usaintTokenInfo: UsaintTokenInfo?
    
    //MARK: Property
    var alertMessage: String = "다시 확인해주세요."
    
    //MARK: Function
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    func sendTokenToServer(completion: @escaping (Bool) -> Void) {
        provider.request(.login(sToken: usaintTokenInfo?.sToken ?? "", sIdNo: usaintTokenInfo?.sIdno ?? 0)) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(response):
                        if let tokenResponse = try? response.map(TokenResponse.self) {
                            TokenManager.shared.accessToken = tokenResponse.accessToken
                            TokenManager.shared.refreshToken = tokenResponse.refreshToken
                            UserDefaults.standard.set(tokenResponse.studentNo, forKey: "studentNumber")
                            print("⭐️\(tokenResponse.refreshToken)")
                            completion(true)
                        } else {
                            print("🚨 로그인 API 파싱 실패 :  Invalid response from server")
                            completion(false)
                        }
                    case .failure:
                        print("🚨 로그인 API 네트워크 실패")
                        completion(false)
                    }
                }
        }
    }
    
    func logOut() {
        loginSuccess = false
        isAuthenticating = false
    }

}

struct UsaintTokenInfo {
    var sToken: String
    var sIdno: Int
}

struct TokenResponse: Decodable {
    var accessToken: String
    var refreshToken: String
    var studentNo: String
}
