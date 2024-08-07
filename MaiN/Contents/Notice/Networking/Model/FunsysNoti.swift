//
//  FunsysNoti.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation

struct FunsysNoti: Decodable, Equatable {
    var id: Int
    var title: String
    var link: String
    var startDate: String
    var endDate: String
    var favorites: Bool
}
