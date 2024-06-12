//
//  FunsysNotiAPI.swift
//  MaiN
//
//  Created by 김수민 on 1/12/24.
//

import Foundation
import Moya

enum FunsysNotiAPI {
    case funsysNotiFavorites(studentId: String, pageNo: Int)
    case funsysNotiFavoritesAdd(studentId: String, funsysNotiId: Int)
    case funsysNotiFavoritesDelete(studentId: String, funsysNotiId: Int)
}

extension FunsysNotiAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://54.180.221.239")!
    }
    
    var path: String {
        switch self {
        case .funsysNotiFavorites(studentId: let studentId, _):
            return "/funsysnoti/favorites/all/\(studentId)"
        case .funsysNotiFavoritesAdd(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return "/funsysnoti/favorites/delete"
        case .funsysNotiFavoritesDelete(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return "/funsysnoti/favorites/add/"
        }
    }
    
    var method: Moya.Method {
        switch self {
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
        case .funsysNotiFavorites(_, pageNo: let pageNo):
            return .requestParameters(parameters: ["pageNo": pageNo], encoding: URLEncoding.queryString)
        case .funsysNotiFavoritesAdd(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "funsysNotiId": funsysNotiId], encoding: JSONEncoding.default)
        case .funsysNotiFavoritesDelete(studentId: let studentId, funsysNotiId: let funsysNotiId):
            return .requestParameters(parameters: ["studentNo": studentId, "funsysNotiId": funsysNotiId], encoding: JSONEncoding.default)
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
