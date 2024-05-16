//
//  Extension+DateFormatter.swift
//  MaiN
//
//  Created by 김수민 on 5/16/24.
//

import Foundation

enum DateFormatterType {
    case monthYear
    case fullDate

    var formatter: DateFormatter {
        switch self {
        case .monthYear:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy" // 요런식으로 쓰세요! => formatter: DateFormatterType.monthYear.formatter
            return formatter
        case .fullDate:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }
    }
}

