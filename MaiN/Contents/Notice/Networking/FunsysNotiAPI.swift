//
//  FunsysNotiAPI.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya

enum FunsysNotiAPI {
    case funsysNotiAllShow
    case funsysNotiFavorites(studentId: String)
    case funsysNotiFavoritesAdd(studentId: String, funsysNotiId: Int)
    case funsysNotiFavoritesDelete(studentId: String, funsysNotiId: Int)
}

extension FunsysNotiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://43.203.195.189")!
    }
    
    var path: String {
        switch self {
        case .funsysNotiAllShow:
            return "/funsys_noti/all"
        case .funsysNotiFavorites(studentId: let studentId):
            return "/funsysnoti/favorites/all/\(studentId)"
        case .funsysNotiFavoritesAdd(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return "/funsysnoti/favorites/delete/\(studentId)/\(funsysNotiId)"
        case .funsysNotiFavoritesDelete(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return "/funsysnoti/favorites/add/\(studentId)/\(funsysNotiId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .funsysNotiAllShow:
            return .get
        case .funsysNotiFavorites:
            return .get
        case .funsysNotiFavoritesDelete:
            return .delete
        case .funsysNotiFavoritesAdd:
            return .post
        }

    }
    
    var task: Moya.Task {
        switch self {
        case .funsysNotiAllShow:
            return .requestPlain
        case .funsysNotiFavorites(studentId: let studentId):
            return .requestParameters(parameters: ["studentId": studentId], encoding: URLEncoding.queryString)
        case .funsysNotiFavoritesAdd(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "funsysNotiId": funsysNotiId], encoding: URLEncoding.queryString)
        case .funsysNotiFavoritesDelete(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return .requestParameters(parameters: ["studentId": studentId, "funsysNotiId": funsysNotiId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
