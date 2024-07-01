//
//  LogInAPI.swift
//  MaiN
//
//  Created by 김수민 on 5/21/24.
//

import Moya
import Foundation

enum LogInAPI {
    case login(sToken: String, sIdNo: Int)
}

extension LogInAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
//        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(sToken, sIdNo):
            print("\(sToken)")
            print("\(sIdNo)")
            let parameters: [String: Any] = [
                "sToken": sToken,
                "sIdno": sIdNo
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

