//
//  TestUIView.swift
//  MaiN
//
//  Created by 김수민 on 5/16/24.
//

import SwiftUI

struct MonthPicker: View {
    @ObservedObject var vm: ReservationViewModel
    @State private var showingDatePicker = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.showingDatePicker = true
            }) {
                HStack() {
                    Text("\(vm.selectedDate, formatter: DateFormatterType.monthYear.formatter)")
                        .font(.semiBold(size: 17)).foregroundColor(.gray01)
                    Image("calendarArrow").resizable().frame(width: 16, height: 11).rotationEffect(.degrees(showingDatePicker ? 180 : 0))
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePicker("날짜 선택", selection: $vm.selectedDate, 
                           displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .onChange(of: vm.selectedDate) { newDate in
                        showingDatePicker = false
                        vm.fetchWeekReservationAPI(for: newDate)
                    }
                    .presentationDetents([.fraction(0.5)])
            }
        }
    }
}
