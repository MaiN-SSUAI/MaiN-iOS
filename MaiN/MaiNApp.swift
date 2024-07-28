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
        checkScreenSize()
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
        // 앱스토어에서 최신 버전 정보를 가져오는 함수 호출
        fetchLatestVersion { latestVersion in
            guard let latestVersion = latestVersion else { return }
            
            if currentVersion != latestVersion {
                DispatchQueue.main.async {
                    showAlertForUpdate()
                }
            }
        }
    }
    
    func fetchLatestVersion(completion: @escaping (String?) -> Void) {
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let latestVersion = results.first?["version"] as? String {
                    completion(latestVersion)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }

    func showAlertForUpdate() {
        let alert = UIAlertController(title: "업데이트 필요", message: "새 버전이 있습니다. 업데이트 해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id6476232590") {
                UIApplication.shared.open(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkScreenSize() {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight < 800 {
            // se, mini
             UserDefaults.standard.setValue(true, forKey: "mini")
            print("📺small\(UserDefaults.standard.bool(forKey: "mini"))")
        } else {
            // normal
            print("📺big")
            UserDefaults.standard.setValue(false, forKey: "mini")
        }
    }
}

