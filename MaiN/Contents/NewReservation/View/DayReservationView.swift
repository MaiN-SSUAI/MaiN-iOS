//
//  DayReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct DayReservationView: View {
    @ObservedObject var vm: ReservationViewModel
    let colorSet: [ButtonColor] = [.green, .orange, .red, .purple, .blue]
    var body: some View {
        VStack() {
            ForEach(Array(vm.reservations.enumerated()), id: \.element) { index, reservation in
                DayReservationButton(
                    vm: vm,
                    reservation: reservation,
                    color: colorSet[index % colorSet.count]
                )
            }
        }
    }
}

#Preview {
    DayReservationView(vm: ReservationViewModel())
}
