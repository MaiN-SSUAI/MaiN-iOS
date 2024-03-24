//
//  Reservation.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import Foundation
import SwiftUI
import Moya

struct NewReservation: Decodable,Hashable {
    var summary: String
    var eventid: String
    var start: String
    var end: String
    var end_pixel: String
    var start_pixel: String
}
