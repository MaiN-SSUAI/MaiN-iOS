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
    
    func formatDateToStringNoTimeZone() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        return outputFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds, .withTimeZone]
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func convertIsoDateTimeToHour() -> Int? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: self) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            return hour
        } else {
            return nil
        }
    }
}
