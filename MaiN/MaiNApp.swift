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
        checkVersion()
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
        appearance.backgroundColor = .gray00
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func checkVersion() {
        // 앱의 현재 버전 정보 (옛날 버전)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        // 앱스토어에 올라와있는 가장 높은 버전
        let latestVersion = "2.0.5"
        
        if currentVersion < latestVersion {
            DispatchQueue.main.async {
                showAlertForUpdate()
            }
        }
    }

    func showAlertForUpdate() {
        let alert = UIAlertController(title: "업데이트 필요", message: "새 버전이 있습니다. 업데이트 해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6476232590") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        // 현재의 루트 뷰 컨트롤러를 찾아 알림을 표시합니다.
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}

