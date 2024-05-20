//
//  UserDefaultsKeys.swift
//  MaiN
//
//  Created by 김수민 on 1/21/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case isAutoLogin //활성화시 success
    case schoolNumber
    case isLogIn
    case accessToken
    case refreshToken
}


class UserDefaultHandler {
    static let shared = UserDefaultHandler()

    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isAutoLogin.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.schoolNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLogIn.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.refreshToken.rawValue)
    }
}
