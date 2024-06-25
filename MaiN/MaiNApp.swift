//
//  AirisApp.swift
//  Airis
//
//  Created by 김수민 on 12/29/23.
//

import SwiftUI

@main
struct MaiNApp: App {
    @StateObject var vm = LogInViewModel()

    var body: some Scene {
        WindowGroup {
            if (vm.loginSuccess || UserDefaults.standard.bool(forKey: "isAutoLogin")) {
                HomeUIView().environmentObject(vm)
                    .onAppear {
                        checkRefreshToken()
                    }
            } else {
                LogInUIView().environmentObject(vm)
            }
        }
    }

    func checkRefreshToken() {
        isRefreshTokenExpired { isExpired in
            if isExpired {
                DispatchQueue.main.async {
                    vm.loginSuccess = false
                    TokenManager.shared.clearTokens()
                }
            } else {
                print("😎 refreshToken살아있음!")
            }
        }
    }

    func isRefreshTokenExpired(completion: @escaping (Bool) -> Void) {
        TokenManager.shared.refreshAccessToken { success in
            completion(!success)
        }
    }
}

