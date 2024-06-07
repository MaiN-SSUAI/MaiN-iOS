//
//  FunsysNoti.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation

struct FunsysNoti: Decodable {
    var id: Int
    var title: String
    var link: String
    var startDate: String
    var end_date: String
    var favorites: Bool
}

