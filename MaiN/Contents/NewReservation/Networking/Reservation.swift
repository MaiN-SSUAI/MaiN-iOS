//
//  Reservation.swift
//  MaiN
//
//  Created by 김수민 on 6/7/24.
//

import Foundation

struct Reservation: Codable,Hashable, Identifiable {
    var id: Int { reservId }
    var reservId: Int
    var studentNo: [String]
    var start: String
    var end: String
    var start_pixel: String
    var end_pixel: String
    
    //MARK: init
    init(reservId: Int, studentNo: [String], start: String, end: String, start_pixel: String, end_pixel: String) {
        self.reservId = reservId
        self.studentNo = studentNo
        self.start = start
        self.end = end
        self.start_pixel = start_pixel
        self.end_pixel = end_pixel
    }
}

struct WeekReservations: Codable {
    let Mon: [Reservation]
    let Tue: [Reservation]
    let Wed: [Reservation]
    let Thu: [Reservation]
    let Fri: [Reservation]
    let Sat: [Reservation]
    let Sun: [Reservation]
}
