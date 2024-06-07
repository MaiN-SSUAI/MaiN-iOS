//
//  AiNoti.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct AiNoti: Decodable {
    var id: Int
    var title: String
    var link: String
    var date: String
    var favorites: Bool
}
