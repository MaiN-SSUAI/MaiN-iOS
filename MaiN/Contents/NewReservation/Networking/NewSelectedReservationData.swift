//
//  NewSelectedReservationData.swift
//  MaiN
//
//  Created by 김수민 on 2/12/24.
//

import Foundation

class NewSelectedReservationData: ObservableObject {
    @Published var summary: String = ""
    @Published var eventID: String = ""
    @Published var start: String = ""
    @Published var end: String = ""
}
