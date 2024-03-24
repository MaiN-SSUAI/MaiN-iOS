//
//  SsuNotiAPI.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya

enum SsuNotiAPI {
    case ssuNotiAllShow
    case ssuNotiFavorites(studentId: String)
    case ssuNotiFavoritesAdd(studentId: String, ssucatchNotiId: Int)
    case ssuNotiFavoritesDelete(studentId: String, ssucatchNotiId: Int)
}

extension SsuNotiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.203.195.189")!
    }
    
    var path: String {
        switch self {
        case .ssuNotiAllShow:
            return "/ssucatch_noti/all"
        case .ssuNotiFavorites(studentId: let studentId):
            return "/ssucatchnoti/favorites/all/\(studentId)"
        case .ssuNotiFavoritesAdd(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return "/ssucatchnoti/favorites/add/\(studentId)/\(ssucatchNotiId)"
        case .ssuNotiFavoritesDelete(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return "/ssucatchnoti/favorites/delete/\(studentId)/\(ssucatchNotiId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .ssuNotiAllShow:
            return .get
        case .ssuNotiFavorites:
            return .get
        case .ssuNotiFavoritesDelete:
            return .delete
        case .ssuNotiFavoritesAdd:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .ssuNotiAllShow:
            return .requestPlain
        case .ssuNotiFavorites(studentId: let studentId):
            return .requestParameters(parameters: ["studentId": studentId], encoding: URLEncoding.queryString)
        case .ssuNotiFavoritesAdd(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "ssucatchNotiId": ssucatchNotiId], encoding: URLEncoding.queryString)
        case .ssuNotiFavoritesDelete(studentId: let studentId, ssucatchNotiId: let ssucatchNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "ssucatchNotiId": ssucatchNotiId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

