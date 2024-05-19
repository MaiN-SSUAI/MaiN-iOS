//
//  DayReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct DayReservationView: View {
    @ObservedObject var vm: ReservationViewModel

    var body: some View {
        if vm.isLoading {
            ProgressView()
        } else {
            Text("Events: \(vm.reservations.count)")
        }
    }
}
