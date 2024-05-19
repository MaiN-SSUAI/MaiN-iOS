//
//  ReservationViewModel.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

class ReservationViewModel: ObservableObject {
    @Published var isInfoModalPresented: Bool = false
    @Published var selectedDate: Date = Date()

    func showInfoModal() {
        isInfoModalPresented = true
    }
    
    func changeDate(date: Date) {
        selectedDate = date
    }
}
