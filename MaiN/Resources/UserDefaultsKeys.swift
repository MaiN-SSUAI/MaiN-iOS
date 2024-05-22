//
//  UserDefaultsKeys.swift
//  MaiN
//
//  Created by 김수민 on 1/21/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case isAutoLogin //활성화시 success
    case studentNumber
    case isLogIn
    case accessToken
    case refreshToken
}


class UserDefaultHandler {
    static let shared = UserDefaultHandler()

    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "isAutoLogin")
        UserDefaults.standard.removeObject(forKey: "studentNumber")
        UserDefaults.standard.removeObject(forKey: "isLogIn")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}
