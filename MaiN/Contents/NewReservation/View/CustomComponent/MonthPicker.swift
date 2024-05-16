//
//  TestUIView.swift
//  MaiN
//
//  Created by 김수민 on 5/16/24.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedDate: Date
    @State private var showingDatePicker = false
    
    var body: some View {
        VStack {
            Button(action: {
                self.showingDatePicker = true
            }) {
                HStack() {
                    Text("\(selectedDate, formatter: DateFormatterType.monthYear.formatter)")
                        .font(.semiBold(size: 17)).foregroundColor(.gray01)
                    Image("calendarArrow").resizable().frame(width: 16, height: 11).rotationEffect(.degrees(showingDatePicker ? 180 : 0))
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePicker("날짜 선택", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding().onChange(of: selectedDate) { _ in
                                        showingDatePicker = false
                                    }.presentationDetents([.fraction(0.5)])
            }
        }
    }
}

struct MonthPickerPreviews: PreviewProvider {
    static var previews: some View {
        MonthPicker(selectedDate: .constant(Date()))
    }
}
