//
//  AuthAPI.swift
//  MaiN
//
//  Created by 김수민 on 6/20/24.
//

import Foundation
import Moya

enum AuthAPI {
    case refreshAccessToken(accessToken: String, refreshToken: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
//        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .refreshAccessToken:
            return "/users/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshAccessToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .refreshAccessToken(let accessToken, let refreshToken):
            return .requestParameters(parameters: ["accessToken": accessToken, "refreshToken": refreshToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
