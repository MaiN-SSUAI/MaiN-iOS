//
//  AiNotiAPI.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation
import Moya

enum AiNotiAPI {
    case aiNotiFavorites(studentNo: String, pageNo: Int)
    case aiNotiFavoritesAdd(studentId: String, aiNotiId: Int)
    case aiNotiFavoritesDelete(studentId: String, aiNotiId: Int)
}

extension AiNotiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
    }
    
    var path: String {
        switch self {
        case .aiNotiFavorites(let studentNo, _):
            return "/ainoti/favorites/all/\(studentNo)"
        case .aiNotiFavoritesDelete(let studentId, let aiNotiId):
            return "/ainoti/favorites/delete"
        case .aiNotiFavoritesAdd(studentId: let studentId, aiNotiId: let aiNotiId):
            return "/ainoti/favorites/add"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .aiNotiFavorites:
            return .get
        case .aiNotiFavoritesDelete:
            return .delete
        case .aiNotiFavoritesAdd:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .aiNotiFavorites(_, let pageNo):
            return .requestParameters(parameters: ["pageNo": pageNo], encoding: URLEncoding.queryString)
        case .aiNotiFavoritesAdd(studentId: let studentId, aiNotiId: let aiNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "aiNotiId": aiNotiId], encoding: JSONEncoding.default)
        case .aiNotiFavoritesDelete(studentId: let studentId, aiNotiId: let aiNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "aiNotiId": aiNotiId], encoding: JSONEncoding.default)
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
