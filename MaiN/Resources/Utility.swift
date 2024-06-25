//
//  Utility.swift
//  MaiN
//
//  Created by 김수민 on 1/25/24.
//

import Foundation

// 날짜를 문자열로 변환하는 유틸리티 확장
extension Date {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    // 2023-05
    func toDateTimeString() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.string(from: self)
    }
    
    func formatDateToString() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 9 * 3600) // +09:00 시간대
        return outputFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds, .withTimeZone]
        return dateFormatter.date(from: self) ?? Date()
    }
}
