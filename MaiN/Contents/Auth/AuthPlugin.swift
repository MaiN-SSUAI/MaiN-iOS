//
//  AuthPlugin.swift
//  MaiN
//
//  Created by 김수민 on 6/20/24.
//

import Foundation
import Moya

final class AuthPlugin: PluginType {
    var onRetrySuccess: (() -> Void)?
    var onRetryFail: (() -> Void)?
    var loginViewModel: LogInViewModel?
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if response.statusCode == 401 {
                // 토큰이 만료된 경우
                TokenManager.shared.refreshAccessToken { success in
                    if success {
                        // 토큰 갱신 성공 시, 원래 요청을 다시 시도합니다.
                        guard var newRequest = response.request else {
                            print("🤢 원래 요청을 생성할 수 없습니다.")
                            return
                        }
                        if let newToken = TokenManager.shared.accessToken {
                            print("😭\(newToken)")
                            newRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: "Authorization")
                        }
                        // 재시도를 위해 URLSession을 사용합니다.
                        let task = URLSession.shared.dataTask(with: newRequest) { data, response, error in
                            if let error = error {
                                print("🤢 재시도 요청 실패: \(error)")
                            } else if let response = response as? HTTPURLResponse {
                                if (200...299).contains(response.statusCode) {
                                    print("😊 재시도 요청 성공: \(response.statusCode)")
                                    DispatchQueue.main.async {
                                        // 재시도 성공 시, onRetrySuccess 클로저 호출
                                        self.onRetrySuccess?()
                                    }
                                } else {
                                    print("🤢 재시도 요청 실패: \(response.statusCode)")
                                }
                            } else {
                                print("🤢 알 수 없는 오류 발생")
                            }
                        }
                        task.resume()
                    } else {
                        print("🤢 refreshToken 만료!!")
                        DispatchQueue.main.async {
                            self.onRetryFail?()
                        }
                    }
                }
            }
        case .failure(let error):
            print("Request failed with error: \(error)")
        }
    }
}


