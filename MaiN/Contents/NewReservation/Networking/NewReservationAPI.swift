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
        }
    }

    var headers: [String : String]? {
        let accessToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdHVkZW50Tm8iOiIyMDIyMTc4OSIsImlhdCI6MTcxODAzODI0MywiZXhwIjoxNzE4MDQ5MDQzfQ.Blae8AVMryyBVtecSUi7nsmUUgD3VTafyHst8tkhB6FlmlfD7RPVVFNlt6DU9_onkEBovPM_asDtFnA-hrChXg"
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}
