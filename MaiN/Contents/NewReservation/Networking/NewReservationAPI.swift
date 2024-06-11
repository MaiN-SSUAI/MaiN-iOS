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
    case addReservation(location: String, student_id: String, startDateTimeStr: String, endDateTimeStr: String)
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
            return "/calendar/add"
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
        case .addReservation(let location, let student_id, let startDateTimeStr, let endDateTimeStr):
            let params: [String: Any] = [
                "location": location,
                "student_id": student_id,
                "startDateTimeStr": startDateTimeStr,
                "endDateTimeStr": endDateTimeStr
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deleteReservation:
            return .requestPlain
        case .checkUser(user: let user, date: let date):
            return .requestParameters(parameters: ["user": user, "date": date], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdHVkZW50Tm8iOiIyMDIyMTc4OSIsImlhdCI6MTcxODExNzc4OSwiZXhwIjoxNzE4MTI4NTg5fQ.tvgjv08PFUEZU9vMZWSaAr5oIQezn1DKgyeADI3jqUNgDQQlOAWJJAHcw_9k302LQj-BLMkOu5GYX4PI9NU7TA"
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
        case .addReservation(location: let location, student_id: let student_id, startDateTimeStr: let startDateTimeStr, endDateTimeStr: let endDateTimeStr):
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
