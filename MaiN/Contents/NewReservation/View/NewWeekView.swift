//
//  NewWeekView.swift
//  MaiN
//
//  Created by 김수민 on 1/23/24.
//

import SwiftUI

struct NewWeekView: View {
    
    @Binding var selectedDate: Date
    
   private func updateSelectedDate(to newDate: Date) {
       self.selectedDate = newDate
   }
   var body: some View {
       GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { offset in
                        let day = Calendar.current.date(byAdding: .day, value: offset, to: selectedDate.startOfWeek!)!
                        let dayString = changeToKorean(englishDate: dayOfWeekFormatter.string(from: day))
                        
                        let dateString = dateOfWeekFormatter.string(from: day)
                        Button(action: {self.updateSelectedDate(to: day)}){
                            VStack() {
                                Text(dayString)
                                    .foregroundColor(.gray01)
                                    .font(.normal(size: 14))
                                
                                Text(dateString)
                                    .foregroundColor(.black)
                                    .font(.normal(size: 21))
                            }
                            .frame( width: geometry.size.width/7, height: 61)
                            .background(isSameDay(day1: day, day2: selectedDate) ? .blue01 : Color.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }

    private func isSameDay(day1: Date, day2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(day1, inSameDayAs: day2)
    }
}

#Preview {
    NewWeekView(selectedDate: .constant(Date()))
}
