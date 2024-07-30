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
    let isMini: Bool = UserDefaults.standard.bool(forKey: "mini")
    
    var body: some View {
        VStack(spacing: 0) {
            TopReservationView(vm: reservationVM)
            if reservationVM.dayOrWeek == "day" {
                TabView(selection: $reservationVM.selectedDateIndex) {
                    BottomReservationView(vm: reservationVM, index: 0).padding(.top, 10).tag(0)
                    BottomReservationView(vm: reservationVM, index: 1).padding(.top, 10).tag(1)
                    BottomReservationView(vm: reservationVM, index: 2).padding(.top, 10).tag(2)
                    BottomReservationView(vm: reservationVM, index: 3).padding(.top, 10).tag(3)
                    BottomReservationView(vm: reservationVM, index: 4).padding(.top, 10).tag(4)
                    BottomReservationView(vm: reservationVM, index: 5).padding(.top, 10).tag(5)
                    BottomReservationView(vm: reservationVM, index: 6).padding(.top, 10).tag(6)
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            } else {
                BottomReservationView(vm: reservationVM, index: 0).padding(.top, 10).tag(6)
            }
        }
        .background(.white)
        .sheet(isPresented: $reservationVM.isRegisterModalPresented) {
            RegisterModalView(vm: reservationVM, startTime: reservationVM.selectedDate, endTime: reservationVM.selectedDate.addingTimeInterval(3600))
                .presentationDetents(isMini ? [.fraction(0.8)] : [.fraction(0.65)])
        }
        .sheet(isPresented: $reservationVM.isInfoModalPresented) {
            InfoModalView()
                .presentationDetents(isMini ? [.fraction(0.5)] : [.fraction(0.45)])
        }
        .alert(isPresented: $reservationVM.showAlert) {
            Alert(title: Text(""), message: Text(reservationVM.alertMessage ?? "No message"), dismissButton: .default(Text("확인")))
        }
    }
}

#Preview {
    ReservationView()
}
