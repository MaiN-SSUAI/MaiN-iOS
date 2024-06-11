//
//  ReservationUIView.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import SwiftUI

struct ReservationView: View {
    @ObservedObject private var reservationVM = ReservationViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TopReservationView(vm: reservationVM)
            BottomReservationView(vm: reservationVM)
        }
        .background(.white)
        .sheet(isPresented: $reservationVM.isRegisterModalPresented) {
            RegisterModalView(vm: reservationVM)
                .presentationDetents([.fraction(0.55)])
        }
        .sheet(isPresented: $reservationVM.isDetailModalPresented) {
            DetailReservModalView()
        }
    }
}

#Preview {
    ReservationView()
}
