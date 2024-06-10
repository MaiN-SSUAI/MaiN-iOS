//
//  TopReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct TopReservationView: View {
    @ObservedObject var vm: ReservationViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text("세미나실 예약").font(.interRegular(size: 24)).foregroundColor(.black)
                Spacer()
                Button(action: vm.showInfoModal)
                    {Image("info").frame(width: 30, height: 30)}
            }
            
            HStack() {
                MonthPicker(vm: vm)
                Spacer()
                DayWeekPicker(vm: vm).frame(width: 100, height: 28)
            }
            
            WeekView(vm: vm)
        }
        .padding(.horizontal, 28).padding(.vertical, 15)
        .background(Color.white)
        .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        .shadow(color: Color.gray.opacity(0.1), radius: 10, x: 0, y: 10)
//        .onChange(of: vm.selectedDate, {vm.trigger = true})
    }
}
