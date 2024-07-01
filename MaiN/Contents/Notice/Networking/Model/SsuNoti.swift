//
//  SsuCatchNoti.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation
import CoreLocation
struct SsuNoti: Decodable, Equatable {
    var id: Int
    var title: String
    var link: String
    var progress: String
    var category: String
    var favorites: Bool
    var sDate: String
}
