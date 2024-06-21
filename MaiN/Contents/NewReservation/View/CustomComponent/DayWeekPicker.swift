//
//  DayWeekPicker.swift
//  MaiN
//
//  Created by 김수민 on 5/16/24.
//

import SwiftUI

struct DayWeekPicker: View {
    let items = ["day", "week"]
    @ObservedObject var vm: ReservationViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    vm.dayOrWeek = item
                }) {
                    Text(item)
                        .font(Font.custom(vm.dayOrWeek == item ? "Lato-SemiBold" : "Lato-Regular", size: 11))
                        .foregroundColor(vm.dayOrWeek == item ? .black : .gray04)
                        .frame(width: 48, height: 24)
                        .background(vm.dayOrWeek == item ? .white : .EFEFEF)
                        .cornerRadius(5)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 2)
        .background(.EFEFEF)
        .cornerRadius(5)

    }
}
