//
//  ReservationUIView.swift
//  Airis
//
//  Created by 김수민 on 1/3/24.
//

import SwiftUI

struct ReservationView: View {
    @EnvironmentObject var loginVM: LogInViewModel
    @ObservedObject private var reservationVM = ReservationViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TopReservationView(vm: reservationVM)
            BottomReservationView(vm: reservationVM).padding(.top, 10)
        }
        .background(.white)
        .sheet(isPresented: $reservationVM.isRegisterModalPresented) {
            RegisterModalView(vm: reservationVM, startTime: reservationVM.selectedDate, endTime: reservationVM.selectedDate.addingTimeInterval(3600))
                .presentationDetents([.fraction(0.65)])
        }
        .sheet(isPresented: $reservationVM.isInfoModalPresented) {
            InfoModalView()
                .presentationDetents([.fraction(0.5)])
        }
        .alert(isPresented: $reservationVM.showAlert) {
            Alert(title: Text(""), message: Text(reservationVM.alertMessage ?? "No message"), dismissButton: .default(Text("확인")))
        }
    }
}

#Preview {
    ReservationView()
}
