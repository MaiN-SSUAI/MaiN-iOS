//
//  SsuNotiAPI.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya

enum SsuNotiAPI {
    case ssuNotiAll(studentId: String)
    case ssuNotiFavorites(studentId: String, pageNo: Int)
    case ssuNotiFavoritesAdd(studentId: String, ssucatchNotiId: Int)
    case ssuNotiFavoritesDelete(studentId: String, ssucatchNotiId: Int)
}

extension SsuNotiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
//        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .ssuNotiFavorites(let studentId, _):
            return "/ssucatchnoti/favorites/all/\(studentId)"
        case .ssuNotiFavoritesAdd(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return "/ssucatchnoti/favorites/add"
        case .ssuNotiFavoritesDelete(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return "/ssucatchnoti/favorites/delete"
        case .ssuNotiAll(let studentId):
            return "/ssucatchnoti/favorites/all/dev/\(studentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ssuNotiFavorites:
            return .get
        case .ssuNotiFavoritesDelete:
            return .delete
        case .ssuNotiFavoritesAdd:
            return .post
        case .ssuNotiAll:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .ssuNotiFavorites(_, let pageNo):
            return .requestParameters(parameters: ["pageNo": pageNo], encoding: URLEncoding.queryString)
        case .ssuNotiFavoritesAdd(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "ssuCatchNotiId": ssucatchNotiId], encoding: JSONEncoding.default)
        case .ssuNotiFavoritesDelete(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "ssuCatchNotiId": ssucatchNotiId], encoding: JSONEncoding.default)
        case .ssuNotiAll:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        guard let accessToken = TokenManager.shared.accessToken else {
            return nil
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}

