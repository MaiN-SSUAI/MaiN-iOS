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
    case deleteReservation(eventId: String)
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
        case .deleteReservation(let eventId):
            return "/calendar/delete/\(eventId)"
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
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdHVkZW50Tm8iOiIyMDIyMTc4OSIsImlhdCI6MTcxODEyODg5OSwiZXhwIjoxNzE4MTM5Njk5fQ.MvC9pupljrCxUPIvjc8JYZajXJrxn28owgDyA49KRM3LqPdSEaxhUYAeT1OQWKl2MEapWbDbsAS5E7xwlxD8yg"
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
        case .deleteReservation(eventId: let eventId):
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
