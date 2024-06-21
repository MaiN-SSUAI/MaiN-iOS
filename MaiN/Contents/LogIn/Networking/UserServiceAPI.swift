//
//  UserServiceAPI.swift
//  MaiN
//
//  Created by 김수민 on 2/4/24.
//


import Foundation
import Moya

enum UserService {
    case addUser(studentId: String)
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
    }

    var path: String {
        switch self {
        case .addUser:
            return "/users/add"
        }
    }

    var method: Moya.Method {
        switch self {
        case .addUser:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .addUser(studentId):
            return .requestParameters(parameters: ["student_id": studentId], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data {
        return Data()
    }
}
