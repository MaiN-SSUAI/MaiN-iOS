//
//  NewReservationAPI.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import Foundation
import Moya

enum NewReservationAPI {
    case getReservation(date: String)
    case getWeekReservation(date: String)
    case addReservation(reserv: ReservInfo)
    case deleteReservation(reservId: Int)
    case checkUser(user: String, date: String)
}

extension NewReservationAPI: TargetType {
    var baseURL: URL { return URL(string: "http://54.180.221.239")! }

    var path: String {
        switch self {
        case .getReservation:
            return "/calendar/events"
        case .getWeekReservation:
            return "/calendar/events/week"
        case .addReservation:
            return "/calendar/add/event"
        case .deleteReservation(let reservId):
            return "/calendar/delete/\(reservId)"
        case .checkUser:
            return "/calendar/check/user"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getReservation:
            return .get
        case .getWeekReservation:
            return .get
        case .addReservation:
            return .post
        case .deleteReservation:
            return .delete
        case .checkUser(user: let user, date: let date):
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getReservation(let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.queryString)
        case .getWeekReservation(let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.queryString)
        case .addReservation(let reserv):
            return .requestJSONEncodable(reserv)
        case .deleteReservation:
            return .requestPlain
        case .checkUser(user: let user, date: let date):
            return .requestParameters(parameters: ["user": user, "date": date], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdHVkZW50Tm8iOiIyMDIyMTc4OSIsImlhdCI6MTcxODE5Mzk3NywiZXhwIjoxNzE4MjA0Nzc3fQ.I-5R4WzoBuvRQ_PrlzTa_Vr4tEKSli07PMw35sXI9dXdMSdvmPZAbwD4xbDkH16Rf_GxdY_mG5hPUlfCOCem2Q"
        switch self {
        case .getReservation(date: let date):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .getWeekReservation(date: let date):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .addReservation(reserv: let reserv):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .deleteReservation(reservId: let reservId):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .checkUser(user: let user, date: let date):
            return [
                "Content-Type": "text/plain",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
}
