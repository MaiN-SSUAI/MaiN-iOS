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
    
    init() {
        configureNavigationBar()
    }
    
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
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        
        // 배경 색상 설정
        appearance.backgroundColor = .gray00  // 예: 시스템 블루 색상 사용
        
        // 타이틀 텍스트 속성 설정
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        // 대형 타이틀 텍스트 속성 설정 (`.large` 모드 사용시)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        // 모든 네비게이션 바 인스턴스에 대해 설정 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

