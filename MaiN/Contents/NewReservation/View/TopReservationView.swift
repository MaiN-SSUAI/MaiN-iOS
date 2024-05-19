//
//  TopReservationView.swift
//  MaiN
//
//  Created by 김수민 on 5/20/24.
//

import SwiftUI

struct TopReservationView: View {
    var vm: ReservationViewModel

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
                DayWeekPicker().frame(width: 200, height: 28)
            }
            
            WeekView(vm: vm)
        }
        .padding(.horizontal, 28).padding(.top, 15)
    }
}
