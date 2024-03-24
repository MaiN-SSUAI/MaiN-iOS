//
//  AiNotiAPI.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation
import Moya

enum AiNotiAPI {
    case aiNotiAllShow
    case aiNotiFavorites(studentId: String)
    case aiNotiFavoritesAdd(studentId: String, aiNotiId: Int)
    case aiNotiFavoritesDelete(studentId: String, aiNotiId: Int)
}

extension AiNotiAPI: TargetType {
    var baseURL: URL { return URL(string: "http://43.203.195.189")! }
    
    var path: String {
        switch self {
        case .aiNotiAllShow:
            return "/ai_noti/all"
        case .aiNotiFavorites(let studentId):
            return "/ainoti/favorites/all/\(studentId)"
        case .aiNotiFavoritesDelete(let studentId, let aiNotiId):
            return "/ainoti/favorites/delete/\(studentId)/\(aiNotiId)"
        case .aiNotiFavoritesAdd(studentId: let studentId, aiNotiId: let aiNotiId):
            return "/ainoti/favorites/add/\(studentId)/\(aiNotiId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .aiNotiAllShow:
            return .get
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
        case .aiNotiAllShow:
            return .requestPlain
        case .aiNotiFavorites(let studentId):
            return .requestParameters(parameters: ["studentId": studentId], encoding: URLEncoding.queryString)
        case .aiNotiFavoritesAdd(studentId: let studentId, aiNotiId: let aiNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "aiNotiId": aiNotiId], encoding: URLEncoding.queryString)
        case .aiNotiFavoritesDelete(studentId: let studentId, aiNotiId: let aiNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "aiNotiId": aiNotiId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
